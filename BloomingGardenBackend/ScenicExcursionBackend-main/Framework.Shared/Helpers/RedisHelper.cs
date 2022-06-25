using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ServiceStack.Redis;
using System.Collections.Concurrent;
using System.Threading;

using NLog;

namespace Framework.Shared.Helpers
{
    public class RedisHelper
    {
        static NLog.Logger logger = NLog.LogManager.GetCurrentClassLogger();

        static bool _IsSubscribedToCacheResetChannel = false;
        const string CACHE_RESET_CHANNEL = "CACHE_RESET_CHANNEL";
        private static void LeecharSubscriber()
        {
            IRedisSubscription subscriber = null;

            try
            {
                using (RedisClient rc = (RedisClient)GetClient())
                {
                    rc.ClientSetName(System.Environment.MachineName);

                    using (subscriber = rc.CreateSubscription())
                    {
                        subscriber.OnMessage += (channel, msg) =>
                        {
                            InMemoryDataCache.Instance.RemoveEntry(msg);
                        };

                        subscriber.SubscribeToChannels(CACHE_RESET_CHANNEL);
                    }
                }
            }
            catch (Exception ex)
            {
                logger.ErrorException("Server disconnected!", ex);

                // Wait for n seconds before trying to reSubscribe
                Thread.Sleep(30000);
                ThreadPool.QueueUserWorkItem(wi => LeecharSubscriber());
            }
        }

        public static void SubscribeToCacheResetChannel()
        {
            if (!_IsSubscribedToCacheResetChannel)
            {
                ThreadPool.QueueUserWorkItem(wi => LeecharSubscriber());
                _IsSubscribedToCacheResetChannel = true;
            }
        }

        public static void PublishResetCacheMessage(string cacheKey)
        {
            using (IRedisClient rc = GetClient())
            {
                rc.PublishMessage(CACHE_RESET_CHANNEL, cacheKey);
            }
        }

        public static IRedisClient GetClient()
        {
            return (new RedisClient(GlobalAppConfigs.RedisServerIP, GlobalAppConfigs.RedisServerPort,
                GlobalAppConfigs.RedisPassword, GlobalAppConfigs.RedisDbID));
        }
    }

    /*
    public class PooledRedisConnection : IDisposable
    {
        static object _locker = new object();
        static int _maxPooledRedisConnections = GlobalAppConfigs.RedisConnectionPoolSize;
        static bool _isInitialized = false;
        static ConcurrentQueue<RedisClient> _redisConnectionPool = new ConcurrentQueue<RedisClient>();
        private RedisClient _actualClient = null;
        public bool enqueueClient = true;

        public RedisClient ActualClient
        {
            get { return _actualClient; }
            set { _actualClient = value; }
        }

        public PooledRedisConnection(string serverIP)
        {
            //lock (_locker)
            //{
            //    if (!_isInitialized)
            //    {
            //        _isInitialized = true;
            //        for (int i = 0; i < _maxPooledRedisConnections; i++)
            //        {
            //            _redisConnectionPool.Enqueue(new RedisClient(serverIP) { Password = GlobalAppConfigs.RedisPassword });
            //        }
            //    }
            //}

            //while (!_redisConnectionPool.TryDequeue(out _actualClient))
            //{
            //    Logger.WriteDebug("Waiting for redis client to get freed...");
            //    Thread.Sleep(100);
            //}

            if (!_redisConnectionPool.TryDequeue(out _actualClient))
            {
                _actualClient = new RedisClient(serverIP) { Password = GlobalAppConfigs.RedisPassword };
            }

            //Logger.WriteDebug("Got a redis client.");
        }

        public void Dispose()
        {
            if (_redisConnectionPool.Count <= _maxPooledRedisConnections)
            {
                if (this.enqueueClient)
                    _redisConnectionPool.Enqueue(_actualClient);
                else
                    _actualClient.Dispose();
            }
            else
            {
                LoggingServices.WriteDebug(string.Format("INFO only:Exceeded Redis Connection pool limit {0}", _maxPooledRedisConnections));
                _actualClient.Dispose();
            }

            _actualClient = null;
            //Logger.WriteDebug("Returned the redis client to the pool.");
        }
    }
    */
}

