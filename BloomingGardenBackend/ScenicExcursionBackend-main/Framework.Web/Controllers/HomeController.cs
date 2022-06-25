using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Adoofy;
using Framework.Application.Services;
using Framework.Shared.Enums;
using Framework.Web.CommonCode;
using Framework.Web.CommonCode.Helpers;
using Framework.Web.Models;
using OfficeOpenXml;

namespace Framework.Web.Controllers
{
    public class HomeController : BaseController
    {
        public ActionResult Index()
        {
            DashboardModel model = new DashboardModel();
            model.DashboardSummary = new List<Shared.DataServices.DashboardSummary>(); //CommonServices.Instance.GetDashboardSummary();
            return View(model);
        }
        public ActionResult SideBar()
        {
            if (Authentication.Instance.User.RolesRights == null)
            {
                Authentication.Instance.User.RolesRights = AuthenticationServices.Instance.GetUserRoleRights(Authentication.Instance.User.UserID);
            }
            var menuNavigations = CommonServices.Instance.GetMenuNavigations();
            return PartialView("_SideBar", menuNavigations);
        }
    }
}
