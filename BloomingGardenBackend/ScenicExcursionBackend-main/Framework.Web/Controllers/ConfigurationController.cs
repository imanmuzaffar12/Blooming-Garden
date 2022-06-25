using Framework.Application.Services;
using Framework.Web.Models;
using Framework.Shared.DataServices;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Framework.Web.CommonCode.Helpers;

namespace Framework.Web.Controllers
{
    public class ConfigurationController : BaseController
    {
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult DynamicSetupScreen(string moduleName, string screenName)
        {
            DynamicSetupScreen dynamicSetupScreen = new DynamicSetupScreen();
            dynamicSetupScreen = CommonServices.Instance.GetDynamicSetupScreen(screenName);
            return View(dynamicSetupScreen);
        }
        public ActionResult EntityDetails()
        {
            return View();
        }
        public ActionResult Entities()
        {
            return View();
        }
        public ActionResult EntityDetailsDropDown(int entityID)
        {
            var list = CommonServices.Instance.GetAllEntityDetails(entityID);
            return PartialView("_EntityDetailsDropDown", list);
        }       
        public ActionResult ApiConfigurations()
        {
            return View();
        }        
        public ActionResult GetDropDownList(string tableName, string columns, string controlID, string key, string value)
        {
            DropDownListModel model = new DropDownListModel();
            model.Data = CommonServices.Instance.GetTableListingData(tableName, columns, string.Empty, string.Empty);
            model.ControlID = controlID;
            model.Key = key;
            model.Value = value;
            model.TableName = tableName;
            return PartialView("_GetDropDownList", model);
        }
        public ActionResult RolesRights(short? roleID)
        {
            RolesRightsModel model = new RolesRightsModel();
            model.Entities = CommonServices.Instance.GetEntities();
            model.Roles = CommonServices.Instance.GetRoles();
            model.Rights = CommonServices.Instance.GetRights();
            if (roleID.HasValue)
            {
                model.RolesRights = CommonServices.Instance.GetRolesRights(roleID.Value);
            }
            model.RoleID = roleID;
            if (Request.IsAjaxRequest())
            {
                return PartialView("_RolesRightsPartial", model);
            }
            return View(model);
        }
        public JsonResult SaveRolesRights(List<RoleRight> RoleRight, short RoleID)
        {
            JsonResult result = new JsonResult();
            result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;
            int userID = Authentication.Instance.User.UserID;
            result.Data = CommonServices.Instance.SaveRoleRights(RoleRight, RoleID, userID);
            UserEntity user = new UserEntity();
            user = Authentication.Instance.User;
            user.RolesRights = CommonServices.Instance.GetUserRoleRights(user.UserID);
            Session["User"] = user;
            return result;
        }
    }
}
