const http = require('http');

// Proxy for Claude Code CLI → Ollama (forces llama3.1, handles streaming)
const PORT = 4000;
const OLLAMA_HOST = 'localhost';
const OLLAMA_PORT = 11434;
const FORCED_MODEL = 'llama3.1';

const server = http.createServer(async (req, res) => {
  console.log(`[PROXY] ${req.method} ${req.url}`);

  // Health check
  if (req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ status: 'ok', proxy: 'claude-ollama', model: FORCED_MODEL }));
    return;
  }

  // GET /v1/models
  if (req.method === 'GET' && req.url === '/v1/models') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
      object: "list",
      data: [
        {
          id: FORCED_MODEL,
          object: "model",
          created: 1677610602,
          owned_by: "local-ollama"
        }
      ]
    }));
    return;
  }

  if (!req.url.startsWith('/v1/')) {
    res.writeHead(404, { 'Content-Type': 'text/plain' });
    res.end('Not Found');
    return;
  }

  let body = '';
  if (req.method !== 'GET' && req.method !== 'HEAD') {
    await new Promise((resolve, reject) => {
      req.on('data', chunk => body += chunk);
      req.on('end', resolve);
      req.on('error', reject);
    });
  }

  let jsonBody = null;
  if (body) {
    try {
      jsonBody = JSON.parse(body);
    } catch (e) {
      console.error('[PROXY] JSON parse error:', e.message);
      res.writeHead(400, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: { message: 'Invalid JSON', type: 'invalid_request' } }));
      return;
    }
  }

  console.log(`[PROXY] Model: ${jsonBody?.model || 'none'} → forcing ${FORCED_MODEL}, stream=${!!jsonBody?.stream}`);

  // Build Ollama request
  const options = {
    hostname: OLLAMA_HOST,
    port: OLLAMA_PORT,
    path: '/api/chat',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    }
  };

  let ollamaBody = body;
  if (jsonBody && jsonBody.messages) {
    const transformContent = (content) => {
      if (typeof content === 'string') return content;
      if (Array.isArray(content)) {
        return content
          .filter(block => block.type === 'text')
          .map(block => block.text)
          .join('\n');
      }
      return String(content);
    };

    const ollamaPayload = {
      model: FORCED_MODEL,
      messages: jsonBody.messages.map(msg => ({
        role: msg.role,
        content: transformContent(msg.content)
      })),
      stream: true, // Always enable streaming from Ollama
      options: jsonBody.options || {}
    };

    if (jsonBody.max_tokens) {
      ollamaPayload.options = ollamaPayload.options || {};
      ollamaPayload.options.num_predict = jsonBody.max_tokens;
    }
    if (jsonBody.temperature) {
      ollamaPayload.options = ollamaPayload.options || {};
      ollamaPayload.options.temperature = jsonBody.temperature;
    }

    ollamaBody = JSON.stringify(ollamaPayload);
  }

  // Make request to Ollama
  const proxyReq = http.request(options, (proxyRes) => {
    console.log(`[PROXY] ← Ollama: status=${proxyRes.statusCode}`);
    
    // Set headers for Claude (must be before streaming)
    res.writeHead(proxyRes.statusCode || 200, {
      'Content-Type': 'application/json',
      'Transfer-Encoding': 'chunked',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive'
    });

    // Stream data from Ollama to Claude
    proxyRes.on('data', (chunk) => {
      res.write(chunk);
    });

    proxyRes.on('end', () => {
      console.log(`[PROXY] ✓ Stream completed`);
      res.end();
    });
  });

  proxyReq.on('error', (err) => {
    console.error('[PROXY ERROR]', err.message);
    res.writeHead(502, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
      error: {
        message: `Proxy error: ${err.message}`,
        type: 'proxy_error',
        code: 'proxy_error'
      }
    }));
  });

  proxyReq.setTimeout(120000, () => {
    console.error('[PROXY] Request timeout (120s)');
    proxyReq.destroy();
    if (!res.headersSent) {
      res.writeHead(504, { 'Content-Type': 'application/json' });
    }
    res.end(JSON.stringify({
      error: {
        message: 'Request timeout',
        type: 'timeout',
        code: 'timeout'
      }
    }));
  });

  if (ollamaBody && req.method !== 'GET' && req.method !== 'HEAD') {
    proxyReq.write(ollamaBody);
  }
  
  proxyReq.end();
});

server.listen(PORT, '127.0.0.1', () => {
  console.log(`╔═══════════════════════════════════════════════════╗`);
  console.log(`║   Claude Proxy - Ollama Bridge                   ║`);
  console.log(`║   Port: ${PORT}                                    ║`);
  console.log(`║   Target: Ollama (localhost:${OLLAMA_PORT})        ║`);
  console.log(`║   Force model: ${FORCED_MODEL}                     ║`);
  console.log(`║   Streaming: enabled                              ║`);
  console.log(`╚═══════════════════════════════════════════════════╝`);
  console.log(`✓ Proxy ready. Claude Code → ${FORCED_MODEL} (no login)`);
});
