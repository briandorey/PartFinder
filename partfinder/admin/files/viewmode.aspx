<%@ Page Language="C#" %>
<script runat="server">
    protected void Page_Load(Object Src, EventArgs E)
    {
        if (Request.QueryString["mode"] != null)
        {
            if (Request.QueryString["mode"].ToString().Equals("icon"))
            {
                HttpCookie myCookie = new HttpCookie("FileManagerView");
                myCookie["ViewMode"] = "icon";
                myCookie.Expires = DateTime.Now.AddYears(2);
                Response.Cookies.Add(myCookie);

            }
            else
            {
                HttpCookie myCookie = new HttpCookie("FileManagerView");
                myCookie["ViewMode"] = "list";
                myCookie.Expires = DateTime.Now.AddYears(2);
                Response.Cookies.Add(myCookie);
            }
        }
    }
</script>
