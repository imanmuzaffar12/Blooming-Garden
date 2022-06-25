using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Reflection;
using System.Diagnostics;
using log4net;

/// <summary>
/// Delegates
/// </summary>
/// <returns></returns>


/// <summary>
/// Summary description for Logger
/// </summary>
public class LoggingServices
{
    public delegate string GetStringDataDlgt(); 
    
    static readonly string DebugLoggerName = "DebugLogger";
    static readonly string InfoLoggerName = "InfoLogger";
    static readonly string WarningLoggerName = "WarningLogger";
    static readonly string ErrorLoggerName = "ErrorLogger";

    static Stack<Stopwatch> _timers = new Stack<Stopwatch>();

    public static GetStringDataDlgt LoggedInUserName;
    public static GetStringDataDlgt ClientIP;
    public static GetStringDataDlgt RequestedUrl;
    public static GetStringDataDlgt Referrer;

    static ILog GetLogger(Type t)
    {
        return (LogManager.GetLogger(t.ToString()));
    }

    public static void WriteLogEntry(LogLevel lvl, Type t, string msg, string additionalData = null, Exception ex = null)
    {
        ILog logger = GetLogger(t);

        if (!string.IsNullOrEmpty(additionalData))
        {
            ThreadContext.Properties["additionalData"] = additionalData;
        }
        if (LoggedInUserName != null)
        {
            ThreadContext.Properties["loggedInUserName"] = LoggedInUserName();
        }
        if (ClientIP != null)
        {
            ThreadContext.Properties["clientIP"] = ClientIP();
        }
        if (RequestedUrl != null)
        {
            ThreadContext.Properties["requestedUrl"] = RequestedUrl();
        }

        switch (lvl)
        {
            case LogLevel.DEBUG: logger.Debug(msg); break;
            case LogLevel.INFO: logger.Info(msg); break;
            case LogLevel.WARN: logger.Warn(msg); break;
            case LogLevel.ERROR: if (ex == null) { logger.Error(msg); } else { logger.Error(msg, ex); } break;
            case LogLevel.FATAL: if (ex == null) { logger.Fatal(msg); } else { logger.Fatal(msg, ex); } break;
        }
    }

    public static void WriteLogEntry(LogLevel lvl, string loggerName, string customMsg, string exMessage, string flatStackTrace)
    {
        ILog logger = LogManager.GetLogger(loggerName);

        switch (lvl)
        {
            case LogLevel.DEBUG: if (!logger.IsDebugEnabled) return; break;
            case LogLevel.INFO: if (!logger.IsInfoEnabled) return; break;
            case LogLevel.WARN: if (!logger.IsWarnEnabled) return; break;
            case LogLevel.ERROR: if (!logger.IsErrorEnabled) return; break;
            case LogLevel.FATAL: if (!logger.IsFatalEnabled) return; break;
        }

        if (exMessage != null)
        {
            ThreadContext.Properties["exMessage"] = exMessage;
        }
        if (flatStackTrace != null)
        {
            ThreadContext.Properties["flatStackTrace"] = flatStackTrace;
        }
        if (LoggedInUserName != null)
        {
            ThreadContext.Properties["loggedInUserName"] = LoggedInUserName();
        }
        if (ClientIP != null)
        {
            ThreadContext.Properties["clientIP"] = ClientIP();
        }
        if (RequestedUrl != null)
        {
            ThreadContext.Properties["requestedUrl"] = RequestedUrl();
        }
        if (Referrer != null)
        {
            ThreadContext.Properties["referrer"] = Referrer();
        }

        switch (lvl)
        {
            case LogLevel.DEBUG: logger.Debug(customMsg); break;
            case LogLevel.INFO: logger.Info(customMsg); break;
            case LogLevel.WARN: logger.Warn(customMsg); break;
            case LogLevel.ERROR: logger.Error(customMsg); break;
            case LogLevel.FATAL: logger.Fatal(customMsg); break;
        }
    }

    public static void WriteLogEntryWithAutomaticTypeResolution(LogLevel lvl, string msg, string additionalData = null, Exception ex = null, int stackFrameIndex = 1)
    {
        MethodBase method = new StackTrace().GetFrame(stackFrameIndex).GetMethod();

        ThreadContext.Properties["fullyQualifiedMemberName"] = string.Format("{0}.{1}()", method.DeclaringType.FullName, method.Name);

        if (LoggedInUserName != null)
        {
            ThreadContext.Properties["loggedInUserName"] = LoggedInUserName();
        }
        if (ClientIP != null)
        {
            ThreadContext.Properties["clientIP"] = ClientIP();
        }
        if (RequestedUrl != null)
        {
            ThreadContext.Properties["requestedUrl"] = RequestedUrl();
        }

        WriteLogEntry(lvl, method.DeclaringType, msg, additionalData, ex);
    }

    public static void WriteDebug(string msgFormat, params object[] args)
    {
        WriteLogEntry(LogLevel.DEBUG, DebugLoggerName, string.Format(msgFormat, args), null, null);
    }

    public static void WriteInfo(string msgFormat, params object[] args)
    {
        WriteLogEntry(LogLevel.INFO, InfoLoggerName, string.Format(msgFormat, args), null, null);
    }

    public static string GetExecutingFunctionName()
    {
        MethodBase method = new StackTrace().GetFrame(1).GetMethod();

        return (string.Format("{0}.{1}()", method.DeclaringType != null ? method.DeclaringType.Name : "NO_DECLARING_TYPE_FOUND", method.Name));
    }

    public static void WriteExecutingFunctionNameAtDebugLevel()
    {
        MethodBase method = new StackTrace().GetFrame(1).GetMethod();

        string msg = string.Format("Function Called::[{0}.{1}()]", method.DeclaringType != null ? method.DeclaringType.FullName : "NO_DECLARING_TYPE_FOUND", method.Name);

        if (LoggedInUserName != null)
        {
            ThreadContext.Properties["loggedInUserName"] = LoggedInUserName();
        }
        if (ClientIP != null)
        {
            ThreadContext.Properties["clientIP"] = ClientIP();
        }
        if (RequestedUrl != null)
        {
            ThreadContext.Properties["requestedUrl"] = RequestedUrl();
        }

        WriteLogEntry(LogLevel.DEBUG, method.DeclaringType, msg);
    }

    public static void WriteWarning(string msgFormat, params object[] args)
    {
        WriteLogEntry(LogLevel.WARN, WarningLoggerName, string.Format(msgFormat, args), null, null);
    }

    public static void WriteError(Exception ex, bool noStackTrace = false)
    {
        string flattenedStackTrace = noStackTrace ? string.Empty : GetFlattenedStackTrace(ex.StackTrace);

        WriteLogEntry(LogLevel.ERROR, ErrorLoggerName, "(null)", ex.Message, flattenedStackTrace);
    }

    public static void WriteError(Exception ex, string customMsg, bool noStackTrace = false)
    {
        string flattenedStackTrace = noStackTrace ? string.Empty : GetFlattenedStackTrace(ex.StackTrace);

        WriteLogEntry(LogLevel.ERROR, ErrorLoggerName, customMsg, ex.Message, flattenedStackTrace);
    }

    public static void LogMethodEntry()
    {
        WriteLogEntryWithAutomaticTypeResolution(LogLevel.DEBUG, "Entered.", null, null, 2);
    }

    public static void LogMethodExit()
    {
        WriteLogEntryWithAutomaticTypeResolution(LogLevel.DEBUG, "Exited.", null, null, 2);
    }

    public static void StartTimer()
    {
        _timers.Push(Stopwatch.StartNew());
    }

    public static void StopTimerAndWriteToLog(string msgPrefix, string msgSuffix = "", string additionalData = null, LogLevel lvl = LogLevel.DEBUG)
    {
        Stopwatch sw = _timers.Pop();
        sw.Stop();

        WriteLogEntryWithAutomaticTypeResolution(lvl, string.Format("{0} took {1} ms. {2}", msgPrefix, sw.ElapsedMilliseconds, msgSuffix), null, null, 3);
    }

    public static void StopTimerAndWriteToLog()
    {
        StopTimerAndWriteToLog(string.Empty);
    }

    private static string GetFlattenedStackTrace(string stackTrace)
    {
        try
        {
            string[] stacks = stackTrace.Replace("\r\n", "").Split(new string[] { " at " }, StringSplitOptions.None);
            string flattenedStackTrace = string.Empty;

            foreach (var stack in stacks)
            {
                if (stack.StartsWith("Argaam"))
                {
                    if (flattenedStackTrace != string.Empty)
                    {
                        flattenedStackTrace += " <= ";
                    }
                    flattenedStackTrace += stack.Trim().Split(new string[] { " in " }, StringSplitOptions.None)[0];
                }
            }

            return (flattenedStackTrace);
        }
        catch (Exception ex)
        {
            return ("Error in flattening StackTrace");
        }
    }

    public static void SendEmail(string msg, Exception ex)
    {
        //string subject = string.Format("{0}-CK={1}", "Async Update failed", cacheKey);
        //EmailNotifier emn = new EmailNotifier(AppConfigHelper.Instance.SendNotificationToInCaseOfError, "error@argaam.com", subject, ex);
        //string status = emn.SendNotification();

        //Logger.WriteDebug(string.Concat("(Async Update Failed) ", status));
    }

    //public static bool IsDebugEnabled
    //{
    //    get {
    //        return (LogManager.GetLogger(DebugLoggerName).IsDebugEnabled);
    //    }
    //}

    //public static bool IsWarnEnabled
    //{
    //    get
    //    {
    //        return (LogManager.GetLogger(WarningLoggerName).IsWarnEnabled);
    //    }
    //}
}

public enum LogLevel
{
    DEBUG,
    INFO,
    WARN,
    ERROR,
    FATAL
}
