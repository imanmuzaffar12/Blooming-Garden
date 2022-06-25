using System.Web.Http;
using System.Web.Mvc;

namespace Framework.Areas.V1
{
    public class V1AreaRegistration : AreaRegistration
    {
        public override string AreaName
        {
            get
            {
                return "V1";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context)
        {

            string[] ns = new[] { "Framework.Areas." + AreaName + ".Controllers" };
            string defaultURL = AreaName + "/{resultType}/";

            context.MapRoute("Data", defaultURL + "Data/{name}", new { action = "Data", controller = "API" }, ns);
            context.MapRoute("PostData", defaultURL + "pData/{name}", new { action = "PostData", controller = "API" }, ns);
            context.MapRoute("VerifyQRCode", defaultURL + "verify-qr-code", new { action = "VerifyQRCode", controller = "API" }, ns);
            context.MapRoute("UpdateProfilePhoto", defaultURL + "upload-profile-photo", new { action = "UpdateProfilePhoto", controller = "API" }, ns);

            context.MapRoute(
                "V1_default",
                "V1/{controller}/{action}/{id}",
                new { action = "Index", controller = "Home" }, ns
            );
        }
    }
}