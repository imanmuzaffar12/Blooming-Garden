using Adoofy.CommonCode;
using Framework.Shared.Helpers;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Mail;
using System.Threading.Tasks;
using System.Web;

namespace Framework.Web.CommonCode.Helpers
{
    public static class BroadcastHelper
    {
        public static string FromEmailAddress = ConfigurationManager.AppSettings["EmailSender"].ToString();
        public static string FromPassword = ConfigurationManager.AppSettings["EmailPassword"].ToString();
        public static string Host = ConfigurationManager.AppSettings["Host"].ToString();
        public static int Port = int.Parse(ConfigurationManager.AppSettings["Port"].ToString());
        public static string ControlPanelUrl = ConfigurationManager.AppSettings["ControlPanelUrl"].ToString();

        public static async Task SendEmailAsync(string name, string subject, string recipientEmail, string password, string link, string business, string points, string expiryDate, string template)
        {
            MailMessage mailMessage = new MailMessage();
            mailMessage.Subject = subject;
            string body = template == "Registration" ? EmailTemplates.Registration : EmailTemplates.ForgotPassword;
            mailMessage.Body = body.Replace("##NAME##", name).Replace("##LINK##", link).Replace("##EMAIL##", recipientEmail).Replace("##PASSWORD##", password.Decrypt()).Replace("##BUSINESS##", business).Replace("##POINTS##", points).Replace("##EXPIRYDATE##", expiryDate);
            mailMessage.To.Add(recipientEmail);
            mailMessage.From = new MailAddress(FromEmailAddress);
            mailMessage.IsBodyHtml = true;
            using (var smtpClient = new SmtpClient())
            {
                smtpClient.Host = Host;
                smtpClient.Port = Port;
                smtpClient.EnableSsl = true;
                smtpClient.Credentials = new System.Net.NetworkCredential(FromEmailAddress, FromPassword);
                try
                {
                    await smtpClient.SendMailAsync(mailMessage);
                }
                catch (Exception ex)
                {

                }
            }
        }
        public static bool SendEmail(string name, string subject, string recipientEmail, string password, string link, string business, string points, string template)
        {
            bool result = false;
            MailMessage mailMessage = new MailMessage();
            mailMessage.Subject = subject;
            string body = template == "Registration" ? EmailTemplates.Registration : template == "ForgotPassword" ? EmailTemplates.ForgotPassword : template == "EarnedPoints" ? EmailTemplates.EarnedPoints : EmailTemplates.ConsumedPoints;
            mailMessage.Body = body.Replace("##NAME##", name).Replace("##LINK##", link).Replace("##EMAIL##", recipientEmail).Replace("##PASSWORD##", password.Decrypt()).Replace("##BUSINESS##", business).Replace("##POINTS##", points);
            mailMessage.To.Add(recipientEmail);
            mailMessage.From = new MailAddress(FromEmailAddress);
            mailMessage.IsBodyHtml = true;
            using (var smtpClient = new SmtpClient())
            {
                smtpClient.Host = Host;
                smtpClient.Port = Port;
                smtpClient.EnableSsl = true;
                smtpClient.Credentials = new System.Net.NetworkCredential(FromEmailAddress, FromPassword);
                try
                {
                    smtpClient.Send(mailMessage);
                    result = true;
                }
                catch (Exception ex)
                {
                    result = false;
                }
            }
            return result;
        }
    }
}