using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Adoofy.CommonCode
{ 
    public class HelpRegistrar : Attribute
    {
        bool _isControler;
        Type _type;
        string _controllerName;
        string _headers;
        public HelpRegistrar(string controllerName)
        {
            _isControler = true;
        }
        public HelpRegistrar(string controllerName, Type returnType)
        {
            _isControler = false;
            this._type = returnType;
        }
        public HelpRegistrar(string controllerName, Type returnType, string headers)
        {
            _isControler = false;
            this._type = returnType;
            _headers = headers;
        }
        public bool IsControler { get { return _isControler; } }
        public Type Type { get { return _type; } }
        public string ControlerName { get { return _controllerName; } }
    }
}