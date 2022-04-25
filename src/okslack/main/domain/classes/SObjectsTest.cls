@IsTest
private class SObjectsTest {
    @IsTest
    static void testCollection() {
        Account acc = new Account(Name = '1');
        SObjects accounts = new SObjects(Account.SObjectType);
        Assert.isTrue(accounts.isEmpty());
        Assert.isFalse(accounts.isNotEmpty());
        accounts.add(acc);
        Assert.isEqual(1, accounts.size());
        Assert.isTrue(accounts.contains(acc));
        Assert.isFalse(accounts.contains(new Account(Name = '1', Description = 'desc')));
        Assert.notNull(accounts.get(0));
        Assert.isEqual(0, accounts.indexOf(acc));
        Assert.isFalse(accounts.isEmpty());
        Assert.isTrue(accounts.isNotEmpty());
        Account accRemoved = (Account) accounts.remove(0);
        Assert.isEqual(acc.Name, accRemoved.Name);
        accounts.addAll(new List<Account>{
                acc
        });
        accounts.addAll(new Set<SObject>{
                acc
        });
        Assert.isEqual(2, accounts.getList().size());
        Assert.isEqual(0, accounts.getRecordsById().size());
        Assert.isEqual(0, accounts.getRecordIds().size());
        accounts.clear();
        Assert.isTrue(accounts.isEmpty());
        Assert.isEqual(Account.SObjectType, accounts.getSObjectType());
        Assert.notNull(accounts.toString());
        Assert.notNull(accounts.getDescribe());
        acc.Id = getMockId(Account.SObjectType);
        accounts = new SObjects(new List<SObject>{
                acc
        }, Account.SObjectType);
        Assert.isEqual(1, accounts.getRecordsById().size());
        Assert.isEqual(1, accounts.getRecordIds().size());
        Assert.isTrue(accounts.containsAll(new SObjects(new List<SObject>{
                acc
        }, Account.SObjectType)));
        Assert.isEqual(Account.SObjectType, accounts.newSObject().getSObjectType());
        SObjects cloned = accounts.clone(true);
        Assert.isTrue(accounts.containsAll(cloned));
        Set<SObject> nullSet = null;
        Assert.isFalse(accounts.containsAll(nullSet));
        cloned.add(new Account(Name = '2'));
        Assert.isFalse(accounts.containsAll(cloned));
    }

    @IsTest
    static void testEqualsHashCode() {
        Account acc = new Account(Name = '1');
        Account acc2 = new Account(Name = '1');
        Account acc3 = new Account(Name = '2');
        SObjects accounts = new SObjects(Account.SObjectType);
        accounts.add(acc);
        SObjects accounts2 = new SObjects(Account.SObjectType);
        accounts2.add(acc2);
        SObjects accounts3 = new SObjects(Account.SObjectType);
        accounts3.add(acc3);
        Assert.isEqual(accounts, accounts2);
        Assert.isEqual(accounts.hashCode(), accounts2.hashCode());
        Assert.isTrue(accounts.equals(accounts2));
        Assert.notEqual(accounts, accounts3);
        Assert.isFalse(accounts.equals(accounts3));
    }

    @IsTest
    static void testGlobalDescribe() {
        Assert.notNull(SObjects.getGlobalDescribe());
        Assert.isTrue(SObjects.getGlobalDescribe().containsKey('Account'));
    }

    private static Map<SObjectType, Long> mockIdCountBySObjectType = new Map<SObjectType, Long>();
    
    public static Id getMockId(SObjectType sObjType) {
        String keyPrefix = sObjType.getDescribe().getKeyPrefix();
        Long mockIdCount = mockIdCountBySObjectType.containsKey(sObjType) ? mockIdCountBySObjectType.get(sObjType) + 1 : 500;
        mockIdCountBySObjectType.put(sObjType, mockIdCount);
        String uniqueSuffix = String.valueOf(mockIdCount);
        String idString = keyPrefix + '0'.repeat(12 - uniqueSuffix.length()) + uniqueSuffix;
        return Id.valueOf(idString);
    }
}