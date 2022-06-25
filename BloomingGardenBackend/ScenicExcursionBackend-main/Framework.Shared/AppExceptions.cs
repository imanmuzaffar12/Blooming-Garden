using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Basketo.Shared
{
    public class IdenticalMethodException : ApplicationException
    {
        public IdenticalMethodException(string msg)
            : base(msg)
        {
        }
    }

    public class MethodNotUsedException : ApplicationException
    {
    }
}
