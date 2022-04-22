global class UnmanagedLimitsUtils extends ok.LimitsUtils {
    global override Integer getAggregateQueries() {
        return Limits.getAggregateQueries();
    }

    global override Integer getLimitAggregateQueries() {
        return Limits.getLimitAggregateQueries();
    }

    global override Integer getCallouts() {
        return Limits.getCallouts();
    }

    global override Integer getLimitCallouts() {
        return Limits.getLimitCallouts();
    }

    global override Integer getCpuTime() {
        return Limits.getCpuTime();
    }

    global override Integer getLimitCpuTime() {
        return Limits.getLimitCpuTime();
    }

    global override Integer getDmlRows() {
        return Limits.getDmlRows();
    }

    global override Integer getLimitDmlRows() {
        return Limits.getLimitDmlRows();
    }

    global override Integer getDmlStatements() {
        return Limits.getDmlStatements();
    }

    global override Integer getLimitDmlStatements() {
        return Limits.getLimitDmlStatements();
    }

    global override Integer getEmailInvocations() {
        return Limits.getEmailInvocations();
    }

    global override Integer getLimitEmailInvocations() {
        return Limits.getLimitEmailInvocations();
    }

    global override Integer getFutureCalls() {
        return Limits.getFutureCalls();
    }

    global override Integer getLimitFutureCalls() {
        return Limits.getLimitFutureCalls();
    }

    global override Integer getHeapSize() {
        return Limits.getHeapSize();
    }

    global override Integer getLimitHeapSize() {
        return Limits.getLimitHeapSize();
    }

    global override Integer getMobilePushApexCalls() {
        return Limits.getMobilePushApexCalls();
    }

    global override Integer getLimitMobilePushApexCalls() {
        return Limits.getLimitMobilePushApexCalls();
    }

    global override Integer getPublishImmediateDML() {
        return Limits.getPublishImmediateDML();
    }

    global override Integer getLimitPublishImmediateDML() {
        return Limits.getLimitPublishImmediateDML();
    }

    global override Integer getQueries() {
        return Limits.getQueries();
    }

    global override Integer getLimitQueries() {
        return Limits.getLimitQueries();
    }

    global override Integer getQueryLocatorRows() {
        return Limits.getQueryLocatorRows();
    }

    global override Integer getLimitQueryLocatorRows() {
        return Limits.getLimitQueryLocatorRows();
    }

    global override Integer getQueueableJobs() {
        return Limits.getQueueableJobs();
    }

    global override Integer getLimitQueueableJobs() {
        return Limits.getLimitQueueableJobs();
    }

    global override Integer getSoslQueries() {
        return Limits.getSoslQueries();
    }

    global override Integer getLimitSoslQueries() {
        return Limits.getLimitSoslQueries();
    }
}