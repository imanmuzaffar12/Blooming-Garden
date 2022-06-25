using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Framework.Application
{
    public class CommonCode
    {
        public object CloneObject(object copyTo, object copyFrom)
        {
            Type from = copyFrom.GetType();
            PropertyInfo[] fromProperties = from.GetProperties();

            Object p = from.InvokeMember("", System.Reflection.BindingFlags.CreateInstance,
                null, copyFrom, null);
            Object t = from.InvokeMember("", System.Reflection.BindingFlags.CreateInstance,
               null, copyTo, null);

            foreach (PropertyInfo pi in fromProperties)
            {
                if (pi.CanWrite)
                {
                    try
                    {
                        copyTo.GetType().GetProperty(pi.Name).SetValue(copyTo, pi.GetValue(copyFrom), null);
                    }
                    catch (Exception ex)
                    {
                    }
                }
            }

            return copyTo;
        }


        public object ConvertExpandoObject(ExpandoObject source, object example)
        {
            
                IDictionary<string, object> dict = source;

                Type from = example.GetType();
                PropertyInfo[] fromProperties = from.GetProperties();


                Object t = from.InvokeMember("", System.Reflection.BindingFlags.CreateInstance,
                   null, example, null);

                foreach (var item in dict)
                {
                    try
                    {
                        example.GetType().GetProperty(item.Key).SetValue(example, item.Value, null);
                    }
                    catch (Exception ex)
                    {
                    }

                }
                return example;
         
        }
    }
}
