/**
 * Generic SObjects collection.
 */
public virtual class SObjects {
    private List<SObject> records { get; private set; } {
        records = new List<SObject>();
    }
    private DescribeSObjectResult describe;
    private SObjectType type;

    public SObjects(List<SObject> records, SObjectType type) {
        this.records = records?.clone();
        this.type = type;
    }
    
    public SObjects(SObjectType type) {
        this.type = type;
    }

    public void add(SObject element) {
        getList().add(element);
    }

    public void addAll(List<SObject> elements) {
        getList().addAll(elements);
    }

    public void addAll(Set<SObject> elements) {
        getList().addAll(elements);
    }

    public void clear() {
        getList().clear();
    }

    public Boolean contains(SObject value) {
        return getList()?.contains(value);
    }

    public Boolean containsAll(SObjects values) {
        return values == null ? false : containsAll(values.getList());
    }

    public Boolean containsAll(List<SObject> values) {
        return values == null ? false : containsAll(new Set<SObject>(values));
    }

    public Boolean containsAll(Set<SObject> values) {
        if (values == null) {
            return false;
        }
        for (SObject value : values) {
            if (!getList()?.contains(value)) {
                return false;
            }
        }
        return true;
    }

    public virtual SObject get(Integer index) {
        return getList().get(index);
    }

    public virtual SObject getFirst() {
        return isEmpty() ? null : get(0);
    }

    public Integer indexOf(SObject element) {
        return getList().indexOf(element);
    }
    
    public Boolean isEmpty() {
        return getList().isEmpty();
    }

    public Boolean isNotEmpty() {
        return !isEmpty();
    }

    public SObject remove(Integer index) {
        return getList().remove(index);
    }

    public Integer size() {
        return getList().size();
    }
    
    public virtual List<SObject> getList() {
        return records != null ? records : new List<SObject>();
    }

    public virtual Map<Id, SObject> getRecordsById() {
        Map<Id, SObject> result = new Map<Id, SObject>();
        for (SObject sObj : getList()) {
            if (sObj.Id != null) {
                result.put(sObj.Id, sObj);
            }
        }
        return result;
    }

    public virtual Set<Id> getRecordIds() {
        return getRecordsById().keySet();
    }

    public virtual DescribeSObjectResult getDescribe() {
        if (describe == null) {
            describe = getSObjectType().getDescribe();
        }
        return describe;
    }

    public virtual DescribeSObjectResult getDescribe(SObjectDescribeOptions options) {
        return getSObjectType().getDescribe(options);
    }

    public Boolean equals(Object obj) {
        if (obj === this) {
            return true;
        }
        if (!(obj instanceof SObjects) || obj == null) {
            return false;
        }
        SObjects other = (SObjects) obj;
        return getList().equals(other.getList());
    }

    public override Integer hashCode() {
        return getList().hashCode();
    }

    public override String toString() {
        return getList().toString();
    }

    public SObjectType getSObjectType() {
        return type;
    }
    
    public SObject newSObject() {
        return getSObjectType().newSObject();
    }
    
    public SObjects clone(Boolean preserveId) {
        SObjects result = clone();
        result.records = result.getList().clone();
        result.clear();
        for (SObject sObj : getList()) {
            result.add(sObj.clone(preserveId));
        }
        return result;
    }

    public static Map<String, SObjectType> getGlobalDescribe() {
        return globalDescribe;
    }
    
    private static Map<String, SObjectType> globalDescribe {
        get {
            if (globalDescribe == null) {
                globalDescribe = Schema.getGlobalDescribe();
            }
            return globalDescribe;
        }
        private set;
    }

    public static Id parseId(String idString, SObjectType sObjType) {
        try {
            Id theId = Id.valueOf(idString);
            return theId.getSobjectType() == sObjType ? theId : null;
        } catch (Exception ignored) {
            return null;
        }
    }
}   