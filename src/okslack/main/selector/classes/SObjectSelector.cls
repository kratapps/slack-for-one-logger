public abstract inherited sharing class SObjectSelector {
    public abstract SObjectType getSObjectType();
    public abstract List<SObjectField> getSObjectFields();
    private final Boolean useCache;
    private SelectorCache cache;
    protected Boolean enforceSecurity = true; // WITH SECURITY_ENFORCED by default

    public void enforceSecurity(Boolean enforceSecurity) {
        this.enforceSecurity = enforceSecurity;
    }

    protected SObjectSelector(Boolean useCache, SelectorCache cache) {
        this.useCache = useCache;
        this.cache = cache;
    }

    protected Query query() {
        return new Query(getSObjectType()).enforceSecurity(enforceSecurity);
    }

    protected void putCache(Object key, Object result) {
        cache.put(key, result);
    }

    protected Object getCache(Object key) {
        return cache.get(key);
    }

    protected public Boolean isCached(Object key) {
        return useCache && cache.isCached(key);
    }

    public void clearCache() {
        cache.clear();
    }
}