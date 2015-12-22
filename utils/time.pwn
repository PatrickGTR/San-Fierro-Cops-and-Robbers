//Credits to Southclaw for this snippet he posted on SA-MP Forums.
//Source: http://forum.sa-mp.com/showpost.php?p=2879979&postcount=64

#define CTIME_DATE_TIME         "%A %B %d %Y at %X"
#define CTIME_DATE_FILENAME     "%Y-%m-%d (%a-%d-%b)"
#define CTIME_DATE_SHORT        "%x"
#define CTIME_TIME_SHORT        "%X"

#define TIMESTAMP_HOUR    (3600)
#define TIMESTAMP_DAY     (86400)
#define TIMESTAMP_WEEK    (604800)
#define TIMESTAMP_MONTH   (2592000)
#define TIMESTAMP_YEAR    (31536000)

stock TimestampToDateTime(datetime, format[] = CTIME_DATE_TIME)
{
    new
        str[64],
        tm<timestamp>;

    localtime(Time:datetime, timestamp);
    strftime(str, sizeof(str), format, timestamp);
    return str;
}

ConvertSeconds(input, &days, &hour, &mins, &secs)
{
    days = (input % 2592000) / TIMESTAMP_DAY;
    hour = (input % 86400) / TIMESTAMP_HOUR;
    mins = (input % 3600) / 60;
    secs = (input % 60);
}
