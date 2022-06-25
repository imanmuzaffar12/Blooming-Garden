using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Web;

namespace Framework.Web.CommonCode.ExportResource
{
    public static class ExportPDF
    {
        public static string WKHtmlToPdf(string url, string exepath, string dir, string pdfFileName)
        {
            var wkhtml = exepath;
            try
            {
                foreach (var process in Process.GetProcessesByName("wkhtmltopdf.exe"))
                {
                    process.Kill();
                }
                var p = new Process();
                p.StartInfo.CreateNoWindow = true;
                p.StartInfo.RedirectStandardOutput = true;
                p.StartInfo.RedirectStandardError = true;
                p.StartInfo.RedirectStandardInput = true;
                p.StartInfo.StandardOutputEncoding = Encoding.UTF8;
                p.StartInfo.UseShellExecute = false;// needs to be false in order to redirect output
                p.StartInfo.FileName = wkhtml;
                p.StartInfo.WorkingDirectory = dir;

                string switches = "";
                //switches += "--print-media-type ";
                //switches += "--margin-top 10mm --margin-bottom 10mm --margin-right 10mm --margin-left 10mm ";
                //switches += "--page-size A4 ";
                //switches += "--redirect-delay 100";

                p.StartInfo.Arguments = string.Format("{0} {1} {2}", switches, url, pdfFileName);
                p.Start();
                //byte[] buffer = new byte[32768];
                //byte[] file;
                //using (var ms = new MemoryStream())
                //{
                //    while (true)
                //    {
                //        int read = p.StandardOutput.BaseStream.Read(buffer, 0, buffer.Length);
                //        if (read <= 0)
                //        {
                //            break;
                //        }
                //        ms.Write(buffer, 0, read);
                //    }
                //    file = ms.ToArray();
                //}
                // wait or exit     
                p.WaitForExit(420000);
                // read the exit code, close process     
                //int returnCode = p.ExitCode;
                p.Close();
            }
            catch (Exception ex)
            {

            }
            return string.Format("{0}", pdfFileName);
        }
    }
}