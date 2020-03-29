<%@ language="C#" %>
<script runat="server">
   
void Application_Start(object sender, EventArgs e)
{
    WebControl.DisabledCssClass = "customDisabledClassName";
}
void Session_Start(object sender, EventArgs e)    {
   
}
void Session_End(object sender, EventArgs e)    {
	
}
private void application_EndRequest(object sender, EventArgs e)
{
    HttpRequest request = HttpContext.Current.Request;
    HttpResponse response = HttpContext.Current.Response;

    if ((request.HttpMethod == "POST") &&
        (response.StatusCode == 404 && response.SubStatusCode == 13))
    {
        // Clear the response header but do not clear errors and transfer back to requesting page to handle error 
        response.ClearHeaders();
        Response.Write("Sorry, you have tired to upload a file which is over 4Mb in size. Please select a smaller file.");
        //HttpContext.Current.Server.Transfer(request.AppRelativeCurrentExecutionFilePath);
    }
} 
private void Application_Error(object sender, EventArgs e)
{
    if (IsMaxRequestExceededException(this.Server.GetLastError()))
    {
        this.Server.ClearError();
        this.Server.Transfer("~/parts/forms/filetoolarge.aspx");
    }
}

    const int TimedOutExceptionCode = -2147467259;
public static bool IsMaxRequestExceededException(Exception e)
{
    // unhandled errors = caught at global.ascx level
    // http exception = caught at page level

    Exception main;
    var unhandled = e as HttpUnhandledException;

    if (unhandled != null && unhandled.ErrorCode == TimedOutExceptionCode)
    {
        main = unhandled.InnerException;
    }
    else
    {
        main = e;
    }


    var http = main as HttpException;

    if (http != null && http.ErrorCode == TimedOutExceptionCode)
    {
        // hack: no real method of identifying if the error is max request exceeded as 
        // it is treated as a timeout exception
        if (http.StackTrace.Contains("GetEntireRawContent"))
        {
            // MAX REQUEST HAS BEEN EXCEEDED
            return true;
        }
    }

    return false;
}
</script>