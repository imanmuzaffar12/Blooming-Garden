using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using CreativeServices;
using System.Runtime.Serialization;

namespace Framework.Shared.Helpers
{
    public class CreativeServiceHelper
    {
        private static CreativeServiceHelper _singleton = new CreativeServiceHelper();

        public static CreativeServiceHelper Instance
        {
            get { return (_singleton); }
        }

        public readonly string applicationName = ConfigurationManager.AppSettings["CreativeApplicationName"];

        public OperationResult Upload(HttpPostedFileBase file, bool enableWaterMark = true, bool useSmallWaterMark = false, bool toggleQuality = false)
        {
            using (CreativeServicesClient client = new CreativeServicesClient())
            {
                CreativeObject img = new CreativeObject();

                if (enableWaterMark)
                {
                    if (useSmallWaterMark)
                    {
                        img.WaterMarkFileName = ConfigurationManager.AppSettings["ArgaamPlusWaterMarkImageSmall"];
                    }
                    else
                    {
                        img.WaterMarkFileName = ConfigurationManager.AppSettings["ArgaamPlusWaterMarkImage"];
                    }
                }

                img.ActualFileName = file.FileName;
                img.ContentType = file.ContentType;
                int length = file.ContentLength;
                img.FileContents = new byte[length];
                file.InputStream.Read(img.FileContents, 0, length);
                img.ToggleQuality = toggleQuality;
                img.ContentType = file.ContentType ?? "image/jpeg";
                OperationResult or = client.SaveRawCreative(img, applicationName, false);

                return or;
            }

        }

        public OperationResult Upload(FileStream file, string fileName, bool enableWaterMark = true, bool useSmallWaterMark = false, bool toggleQuality = false)
        {
            using (CreativeServicesClient client = new CreativeServicesClient())
            {
                CreativeObject img = new CreativeObject();

                if (enableWaterMark)
                {
                    if (useSmallWaterMark)
                    {
                        img.WaterMarkFileName = ConfigurationManager.AppSettings["ArgaamPlusWaterMarkImageSmall"];
                    }
                    else
                    {
                        img.WaterMarkFileName = ConfigurationManager.AppSettings["ArgaamPlusWaterMarkImage"];
                    }
                }

                img.ActualFileName = fileName;
                img.ContentType = GetContentType(fileName);
                img.FileContents = new byte[file.Length];
                file.Read(img.FileContents, 0, Convert.ToInt32(file.Length));
                img.ToggleQuality = toggleQuality;
                OperationResult or = client.SaveRawCreative(img, applicationName, false);

                return or;
            }

        }

        public OperationResult Upload(FileStream file, string fileName, int maxHeight, int maxWidth, bool enableWaterMark = true, bool useSmallWaterMark = false, bool toggleQuality = false)
        {
            using (CreativeServicesClient client = new CreativeServicesClient())
            {
                CreativeObject img = new CreativeObject();

                if (enableWaterMark)
                {
                    if (useSmallWaterMark)
                    {
                        img.WaterMarkFileName = ConfigurationManager.AppSettings["ArgaamPlusWaterMarkImageSmall"];
                    }
                    else
                    {
                        img.WaterMarkFileName = ConfigurationManager.AppSettings["ArgaamPlusWaterMarkImage"];
                    }
                }

                img.MaxHeight = maxHeight;
                img.MaxWidth = maxWidth;
                img.ActualFileName = fileName;
                img.ContentType = GetContentType(fileName);
                img.FileContents = new byte[file.Length];
                file.Read(img.FileContents, 0, Convert.ToInt32(file.Length));
                img.ToggleQuality = toggleQuality;
                OperationResult or = client.SaveRawCreative(img, applicationName, false);

                return or;
            }

        }

        public OperationResult Upload(HttpPostedFile file, int maxHeigth, int maxWidth, bool enableWaterMark = true, bool useSmallWaterMark = false, bool toggleQuality = false)
        {
            using (CreativeServicesClient client = new CreativeServicesClient())
            {
                CreativeObject img = new CreativeObject();

                if (enableWaterMark)
                {
                    if (useSmallWaterMark)
                    {
                        img.WaterMarkFileName = ConfigurationManager.AppSettings["ArgaamPlusWaterMarkImageSmall"];
                    }
                    else
                    {
                        img.WaterMarkFileName = ConfigurationManager.AppSettings["ArgaamPlusWaterMarkImage"];
                    }
                }

                img.ActualFileName = file.FileName;
                img.ContentType = file.ContentType;
                int length = file.ContentLength;
                img.FileContents = new byte[length];
                file.InputStream.Read(img.FileContents, 0, length);
                FileInfo finfo = new FileInfo(file.FileName);
                if (finfo.Extension.ToLower() == ".png")
                {
                    img.ForcedExtension = finfo.Extension;
                    img.ToggleQuality = false;
                }
                else
                {
                    img.ToggleQuality = toggleQuality;
                }
                //img.Quality = Constants.IMAGE_QUALITY;
                img.MaxHeight = maxHeigth;
                img.MaxWidth = maxWidth;

                OperationResult or = client.SaveRawCreative(img, applicationName, false);

                return or;
            }
        }

        public OperationResult Upload(HttpPostedFileBase file, int maxHeight, int maxWidth, bool enableWaterMark = true, bool useSmallWaterMark = false, bool toggleQuality = false)
        {
            using (CreativeServicesClient client = new CreativeServicesClient())
            {
                CreativeObject img = new CreativeObject();

                if (enableWaterMark)
                {
                    if (useSmallWaterMark)
                    {
                        img.WaterMarkFileName = ConfigurationManager.AppSettings["ArgaamPlusWaterMarkImageSmall"];
                    }
                    else
                    {
                        img.WaterMarkFileName = ConfigurationManager.AppSettings["ArgaamPlusWaterMarkImage"];
                    }
                }

                img.ActualFileName = file.FileName;
                img.ContentType = file.ContentType;
                int length = file.ContentLength;
                img.MaxHeight = maxHeight;
                img.MaxWidth = maxWidth;
                img.FileContents = new byte[length];
                file.InputStream.Read(img.FileContents, 0, length);
                img.ToggleQuality = toggleQuality;
                img.ContentType = file.ContentType ?? "image/jpeg";
                OperationResult or = client.SaveRawCreative(img, applicationName, false);

                return or;
            }

        }

        public OperationResult Thumbnail(int id, int width, int height)
        {
            using (CreativeServicesClient client = new CreativeServicesClient())
            {
                OperationResult or = client.CreateThumbnail(id, height, width);
                return or;
            }
        }

        public OperationResult UploadDocument(HttpPostedFile file)
        {
            using (CreativeServicesClient client = new CreativeServicesClient())
            {
                CreativeObject document = new CreativeObject();

                document.ActualFileName = file.FileName;
                document.ContentType = file.ContentType;
                document.ForcedExtension = file.FileName.Substring(file.FileName.LastIndexOf('.'));
                int length = file.ContentLength;
                document.FileContents = new byte[length];
                file.InputStream.Read(document.FileContents, 0, length);
                OperationResult or = client.StoreDocumentCreative(document, applicationName);

                return or;
            }
        }
        public OperationResult UploadDocument(FileStream file, string fileName, string contentType)
        {
            using (CreativeServicesClient client = new CreativeServicesClient())
            {
                CreativeObject document = new CreativeObject();

                document.ActualFileName = fileName;
                document.ContentType = contentType;
                document.ForcedExtension = fileName.Substring(fileName.LastIndexOf('.'));
                int length = Convert.ToInt32(file.Length);
                document.FileContents = new byte[length];
                file.Read(document.FileContents, 0, length);
                OperationResult or = client.StoreDocumentCreative(document, applicationName);

                return or;
            }
        }

        public OperationResult UploadDocument(HttpPostedFileBase fileBase)
        {
            using (CreativeServicesClient client = new CreativeServicesClient())
            {
                CreativeObject document = new CreativeObject();

                document.ActualFileName = fileBase.FileName;
                document.ContentType = fileBase.ContentType;
                document.ForcedExtension = fileBase.FileName.Substring(fileBase.FileName.LastIndexOf('.'));
                int length = fileBase.ContentLength;
                document.FileContents = new byte[length];
                fileBase.InputStream.Read(document.FileContents, 0, length);
                OperationResult or = client.StoreDocumentCreative(document, applicationName);

                return or;
            }
        }


        public OperationResult UploadDocument(string fileURL)
        {
            using (CreativeServicesClient client = new CreativeServicesClient())
            {
                OperationResult or = client.SaveCreativeFromFile(applicationName, fileURL, string.Empty);

                return or;
            }
        }

        public bool RemoveCreative(int id)
        {
            using (CreativeServicesClient client = new CreativeServicesClient())
            {
                OperationResult or = client.RemoveDocumentCreative(id);

                return or.WasSuccessful;
            }
        }

        public string GetCreativeUrl(int id)
        {
            using (CreativeServicesClient client = new CreativeServicesClient())
            {
                OperationResult or = client.GetCreativeUrl(id);

                if (or.ReturnValue == null)
                {
                    return string.Empty;
                }

                return or.ReturnValue.ToString();
            }
        }

        private string GetContentType(string fileName)
        {
            string contentType = "application/octetstream";
            string ext = fileName.Substring(fileName.LastIndexOf('.'));

            Microsoft.Win32.RegistryKey registryKey = Microsoft.Win32.Registry.ClassesRoot.OpenSubKey(ext);

            if (registryKey != null && registryKey.GetValue("Content Type") != null)
            {
                contentType = registryKey.GetValue("Content Type").ToString();
            }

            return contentType;
        }
    }
}
