public inherited sharing class SelectorCache {
    private Map<Object, Object> results = new Map<Object, Object>();

    public void put(Object key, Object result) {
        results.put(key, result);
    }

    public Object get(Object key) {
        return results.get(key);
    }

    public Boolean isCached(Object key) {
        return results.containsKey(key);
    }
    
    public void clear() {
        results.clear();
    }
}