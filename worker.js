export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    // 1) POST /update  -> Receive and store URL
    if (request.method === "POST" && url.pathname === "/update") {
      const apiKey = request.headers.get("x-api-key");
      if (apiKey !== env.API_KEY) {
        return new Response("Unauthorized", { status: 401 });
      }

      let data;
      try {
        data = await request.json();
      } catch {
        return new Response("Invalid JSON", { status: 400 });
      }

      const target = data?.url;
      if (!target || typeof target !== "string") {
        return new Response("Missing or invalid 'url'", { status: 400 });
      }

      // Persist the URL
      await env.REDIRECT_KV.put("redirect_url", target);

      return new Response(
        JSON.stringify({ status: "ok", saved: target }),
        { headers: { "Content-Type": "application/json" } }
      );
    }

    // 2) GET /  -> Redirect user
    if (request.method === "GET" && url.pathname === "/") {
      const target = await env.REDIRECT_KV.get("redirect_url");

      if (!target) {
        return new Response("No redirect URL configured yet.", { status: 200 });
      }

      return Response.redirect(target, 302);
    }

    // Everything else
    return new Response("Not Found", { status: 404 });
  }
};
