using System;
using System.Web;
using System.Web.UI.WebControls;
using System.Globalization;
using System.Text.RegularExpressions;
using System.IO;
using System.Text;

/// <summary>
/// Summary description for Helpers
/// </summary>
public static class Helpers
{

    public static string GetCondition(string key)
    {

        switch (key)
        {
            case "0":
                return "Used";

            case "1":
                return "New";

            default:
                return "Unknown";

        }
    }
    public static bool QueryStringIsNotNull(string key)
    {
        
        if (HttpContext.Current.Request.QueryString[key] != null)
        {
            return true;
        }

        return false;
    }
    public static int QueryStringReturnNumber(string key)
    {
        int pkey;
        if (HttpContext.Current.Request.QueryString[key] != null && Int32.TryParse(HttpContext.Current.Request.QueryString[key].ToString(), out pkey))
        {
            return pkey;
        }

        return 0;
    }
    public static bool TextBoxIsNull(TextBox key)
    {
        if (key.Text != null && key.Text.Length < 1)
        {
            key.CssClass = "form-control form-control-sm is-invalid";
            return true;
        }
        key.CssClass = "form-control form-control-sm";
        return false;
    }
    public static bool TextBoxIsDouble(TextBox key)
    {
        if (key.Text != null && key.Text.Length > 0)
        {
            double d;
            if (Double.TryParse(key.Text.ToString(), out d)) // if done, then is a number
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        return false;
    }
    public static bool TextBoxIsInt(TextBox key)
        {
            if (key.Text != null && key.Text.Length > 0)
            {
                int d;
                if (Int32.TryParse(key.Text.ToString(), out d)) // if done, then is a number
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            return false;
    }
    public static bool TextBoxIsEmail(TextBox key)
    {
        if (key.Text != null && key.Text.Length > 1)
        {
            IsValidEmail(key.Text.ToString());
        }
        return false;
    }

    public static bool IsValidEmail(string email)
    {
        if (string.IsNullOrWhiteSpace(email))
            return false;

            Regex regex = new Regex(@"^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$");
            Match match = regex.Match(email);
        if (match.Success)
            return true;
        else
            return false;
      
    }

    
    public static string Right(this String strParam, int iLen)
    {
        if (iLen > 0 && strParam.Length > iLen)
            return strParam.Substring(strParam.Length - iLen, iLen);
        else
            return strParam;
    }

    
    public static string Left(this String strParam, int iLen)
    {
        if (iLen > 0 && strParam.Length > iLen)
            return strParam.Substring(0, iLen);
        else
            return strParam;
    }
   
    public static string DoDateFormat(this String inval)
    {
        try
        {
            if (inval.Length > 0)
            {
                return DateTime.Parse(inval).ToString("dd/MM/yyyy");
            }
            else
            {
                return inval;
            }
        }
        catch
        {
            return "Error with Value";
        }
    }

    public static string CleanQS(string key)
    {
        if (HttpContext.Current.Request.QueryString[key] != null)
        {
            string sInput = HttpContext.Current.Request.QueryString[key].ToString();
            sInput = sInput.ToLower().Replace(".", "");
            return Regex.Replace(sInput.ToLower(), "[^a-z0-9 -\\\\]", "");
            
        }
        else
        {
            return "";
        }
    }

    public static string DoSizeFormat(this String inval)
    {
        decimal filesize = System.Convert.ToDecimal(inval);
        string displayvalue = "";
        if (filesize >= 1073741824)
        {
            displayvalue = (filesize / 1024 / 1024 / 1024).ToString("F") + " GB";
        }
        if (filesize >= 1048576)
        {
            displayvalue = (filesize / 1024 / 1024).ToString("F") + " MB";
        }
        if (filesize >= 1024)
        {
            displayvalue = (filesize / 1024).ToString("F") + " KB";
        }
        if (filesize < 1024)
        {
            displayvalue = (filesize).ToString("F") + " B";
        }
        return displayvalue;
    }
    public static string CleanString(this String inval)
    {
        return Regex.Replace(inval, @"[^A-Za-z0-9-]+", "");
    }
    public static string DirectoryName(this String inval)
    {
        return Regex.Replace(inval, @"[^A-Za-z0-9]+", "").ToLower().Replace(" ", "-");
    }
    
     public static void DoLog(string strMsg)
        {
            string filename = System.Web.HttpContext.Current.Server.MapPath("\\changelog.txt");
    
           
            FileStream fs = new FileStream(filename, FileMode.Append, FileAccess.Write, FileShare.Write);
            fs.Close();
            StreamWriter sw = new StreamWriter(filename, true, Encoding.ASCII);
            sw.Write(System.Environment.NewLine + DateTime.Now.ToString() + "," + strMsg);
            sw.Close();
    
    }

}
