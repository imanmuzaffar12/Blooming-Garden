using System;
using System.Collections.Generic;
using System.Configuration;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Security.Principal;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using Microsoft.AspNet.Identity;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json.Linq;

namespace Framework.Web.CommonCode
{
    public static class JwtManager
    {
        private static string Secret = "QmFza2V0byBpcyB0aGUgYmVzdCBNb2JpbGUgQXBwcw==";
        public static string GenerateToken(string userID)
        {
            byte[] key = Convert.FromBase64String(Secret);
            SymmetricSecurityKey securityKey = new SymmetricSecurityKey(key);
            SecurityTokenDescriptor descriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new[] {
                      new Claim(ClaimTypes.Name, userID)}),
                Expires = DateTime.UtcNow.AddMinutes(double.Parse(ConfigurationManager.AppSettings["TokenExpirationTimeInMinutes"].ToString())),
                SigningCredentials = new SigningCredentials(securityKey,
                SecurityAlgorithms.HmacSha256Signature)
            };

            JwtSecurityTokenHandler handler = new JwtSecurityTokenHandler();
            JwtSecurityToken token = handler.CreateJwtSecurityToken(descriptor);
            return handler.WriteToken(token);
        }
        public static ClaimsPrincipal GetPrincipal(string token)
        {
            try
            {
                JwtSecurityTokenHandler tokenHandler = new JwtSecurityTokenHandler();
                JwtSecurityToken jwtToken = (JwtSecurityToken)tokenHandler.ReadToken(token);
                if (jwtToken == null)
                    return null;
                byte[] key = Convert.FromBase64String(Secret);
                TokenValidationParameters parameters = new TokenValidationParameters()
                {
                    RequireExpirationTime = true,
                    ValidateIssuer = false,
                    ValidateAudience = false,
                    IssuerSigningKey = new SymmetricSecurityKey(key)
                };
                SecurityToken securityToken;
                ClaimsPrincipal principal = tokenHandler.ValidateToken(token,
                      parameters, out securityToken);
                return principal;
            }
            catch (Exception e)
            {
                return null;
            }
        }

        public static TokenValidation ValidateToken(string token)
        {
            ClaimsPrincipal principal = GetPrincipal(token);
            if (principal == null)
                return null;
            ClaimsIdentity identity = null;
            try
            {
                identity = (ClaimsIdentity)principal.Identity;
            }
            catch (NullReferenceException)
            {
                return null;
            }
            Claim userIDClaim = identity.FindFirst(ClaimTypes.Name);
            string expirationClaim = identity.FindFirstValue("exp");
            TokenValidation tokenValidation = new TokenValidation();
            tokenValidation.UserID = userIDClaim.Value;


            System.DateTime dtDateTime = new DateTime(1970, 1, 1, 0, 0, 0, 0, System.DateTimeKind.Utc);
            dtDateTime = dtDateTime.AddSeconds(Convert.ToDouble(expirationClaim)).ToLocalTime();
            tokenValidation.Expiration = dtDateTime;
            return tokenValidation;
        }

    }
    public class TokenValidation
    {
        public string UserID { get; set; }
        public DateTime Expiration { get; set; }
    }
}