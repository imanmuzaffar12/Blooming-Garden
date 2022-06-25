using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Framework.Shared.Enums
{
    public enum RightsEnum : short
    {
        Add = 1,
        Update = 2,
        Delete = 3,
        ViewSelf = 4,
        ViewAll = 5
    }
    public enum StatusesEnum : short
    {
        Active = 1,
        Pending = 2,
        Served = 3,
        Completed = 4,
        Rejected = 5
    }
    public enum RolesEnum : short
    {
        Admin = 1,
        Merchants = 2
    }
    public enum LanguagesEnum : short
    {
        Arabic = 1,
        English = 2
    }
    public enum ActionTypesEnum : short
    {
        Change = 0,
        Delete = 1,
        Same = 2
    }
}
