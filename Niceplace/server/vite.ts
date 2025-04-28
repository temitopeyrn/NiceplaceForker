import express, { type Express } from "express";
import fs from "fs";
import path from "path";
import { createServer as createViteServer, createLogger } from "vite";
import { type Server } from "http";
import viteConfig from "../vite.config";
import { nanoid } from "nanoid";
import { fileURLToPath } from 'url';

// ES modules don't have __dirname, so we need to create it
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const viteLogger = createLogger();

export function log(message: string, source = "express") {
  const formattedTime = new Date().toLocaleTimeString("en-US", {
    hour: "numeric",
    minute: "2-digit",
    second: "2-digit",
    hour12: true,
  });

  console.log(`${formattedTime} [${source}] ${message}`);
}

export async function setupVite(app: Express, server: Server) {
  const serverOptions = {
    middlewareMode: true,
    hmr: { server },
    host: '0.0.0.0',
    port: 5000,
  };

  const vite = await createViteServer({
    ...viteConfig,
    configFile: false,
    customLogger: {
      ...viteLogger,
      error: (msg, options) => {
        viteLogger.error(msg, options);
        console.error('Vite error occurred:', msg);
        // Don't exit process on error for better resilience
        // Just log the error and continue
      },
    },
    server: serverOptions,
    appType: "custom",
  });

  app.use(vite.middlewares);
  
  // Special handling for API routes
  app.use("/api/*", (req, res, next) => {
    next(); // Skip Vite handling for API routes
  });
  
  app.use("/facebook_login.html", (req, res, next) => {
    next(); // Skip Vite handling for facebook_login.html
  });
  
  // Handle all other routes with Vite (client-side routing)
  app.use("*", async (req, res, next) => {
    const url = req.originalUrl;
    
    // Skip API routes and direct file access
    if (url.startsWith('/api/') || url.includes('.html')) {
      return next();
    }

    try {
      // Resolve the client template path
      const clientTemplate = path.resolve(
        __dirname,
        "..",
        "client",
        "index.html",
      );

      log(`Serving ${url} with Vite middleware`, "vite");
      
      // Always reload the index.html file from disk in case it changes
      let template = await fs.promises.readFile(clientTemplate, "utf-8");
      template = template.replace(
        `src="/src/main.tsx"`,
        `src="/src/main.tsx?v=${nanoid()}"`,
      );
      const page = await vite.transformIndexHtml(url, template);
      res.status(200).set({ "Content-Type": "text/html" }).end(page);
    } catch (e) {
      vite.ssrFixStacktrace(e as Error);
      console.error('Error in Vite middleware:', e);
      next(e);
    }
  });
}

export function serveStatic(app: Express) {
  const distPath = path.resolve(__dirname, "public");

  if (!fs.existsSync(distPath)) {
    console.warn(`Could not find the build directory: ${distPath}, falling back to client directory.`);
    // Fall back to serving from client directory in development if dist doesn't exist
    app.use(express.static(path.resolve(__dirname, '..', 'client')));
    
    // fall through to index.html if the file doesn't exist
    app.use("*", (_req, res) => {
      res.sendFile(path.resolve(__dirname, '..', 'client', 'index.html'));
    });
    return;
  }

  app.use(express.static(distPath));

  // fall through to index.html if the file doesn't exist
  app.use("*", (_req, res) => {
    res.sendFile(path.resolve(distPath, "index.html"));
  });
}
