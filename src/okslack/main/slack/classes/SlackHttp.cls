/**
 * All HTTP requests are routed through this class.
 */
public virtual class SlackHttp {
    public static List<SlackHttp.HttpRequestLog> requestLogs = new List<SlackHttp.HttpRequestLog>();
    
    public static SlackHttp create() {
        return new SlackHttp();
    }
    
    public HttpResponse send(HttpRequest req) {
        SlackHttp.HttpRequestLog log = new SlackHttp.HttpRequestLog();
        log.endpoint = req.getEndpoint();
        log.body = req.getBody();
        requestLogs.add(log);
        return new Http().send(req);
    }
    
    public class HttpRequestLog {
        public String endpoint;
        public String body;
    }
}