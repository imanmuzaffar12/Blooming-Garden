using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Basketo.Shared
{
    public abstract class CacheableEntity
    {
        public string DbID { get; set; }

        public string GetCacheKey()
        {
            return (GetType().Name + ":" + DbID);
        }

        public abstract void LoadFromDB();
    }
}
