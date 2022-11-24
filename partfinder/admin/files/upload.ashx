<%@ WebHandler Language="C#" Class="upload" %>

using System;
using System.Web;
using System.IO;

public class upload : IHttpHandler {

    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        context.Response.Expires = -1;

        string[] allowedFileTypes = { "swf", "jpg", "gif", "doc", "docx", "zip", "pdf", "xls", "ppt", "txt", "mpg", "png", "mp3", "svg","xlsx", "docx" };
        try
        {
            string ID = context.Request.QueryString["d"];
            HttpFileCollection fileCollection = context.Request.Files;
            bool canupload = false;
            for (int i = 0; i < fileCollection.Count; i++)
            {

                HttpPostedFile upload = fileCollection[i];
                string FfileName = upload.FileName.ToLower().Replace(" ","-").Replace("'","");

                for (int x = 0; x < allowedFileTypes.Length; x++)
                {
                       
                    if  (FfileName.EndsWith(allowedFileTypes[x]))
                    {
                        
                        canupload = true;

                        break;
                    }

                }
                if (canupload)
                {
                    string filename =context.Server.MapPath("/docs/" + ID + "/" + FfileName);
                    upload.SaveAs(filename);
                    context.Response.Write("<div class=\"alert alert-success\" role=\"alert\">The file has been uploaded.<br>Reload page to view.</div>");
                }

                if (!canupload)
                {
                   // context.Response.Write("<div class=\"alert alert-danger\" role=\"alert\">The selected file type is not allowed to be added to your website. " + FfileName + "</div>");

                }


            }
            context.Response.StatusCode = 200;
        }
        catch (Exception ex)
        {
            context.Response.Write("Error: " + ex.Message);
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}