global class UnmanagedLoggerUtils extends ok.LoggerUtils {
    global override String getStackTraceString(Exception e) {
        return e.getStackTraceString();
    }

    global override void debug(LoggingLevel level, Object o) {
        System.debug(level, o);
    }
}