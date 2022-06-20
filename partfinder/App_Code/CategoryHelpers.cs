using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for CategoryHelpers
/// </summary>
public class CategoryHelpers
{
  
    public CategoryHelpers()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    
  
    // Start Drop Down Category Menu Generator
    public  void LoadCatMenu(DropDownList menu, string Index = "0")
    {
        using (DataSet ds = new DataSet())
        {
            //menu.Items.Add(new ListItem("Root", "0"));
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
            {
                connection.Open();
                SqlDataAdapter da = new SqlDataAdapter("SELECT PCpkey, ParentID, PCName FROM PartCategory ORDER BY PCName ASC", connection);
                da.FillSchema(ds, SchemaType.Source, "PartCategory");
                da.Fill(ds, "PartCategory");
                CatMenuSubRepeater("0", menu, ds);
            }
            menu.SelectedValue = Index;
        }
    }

    private void CatMenuSubRepeater(string CatID, DropDownList menu, DataSet ds)
    {
        using (System.Data.DataView dv = new System.Data.DataView())
        {
            dv.Table = ds.Tables["PartCategory"];
            dv.RowFilter = "ParentID = " + CatID;

            dv.Sort = "PCName ASC";
            foreach (DataRowView drv in dv)
            {
                menu.Items.Add(new ListItem(CatSecMenuBuilder(drv["PCpkey"].ToString(), drv["PCName"].ToString(), "", ds), drv["PCpkey"].ToString()));

                CatMenuSubRepeater(drv["PCpkey"].ToString(), menu, ds);
            }
        }
    }

    private string CatSecMenuBuilder(string strSectionID, string strCurrentPage, string strPageName, DataSet ds)
    {
        try
        {
            if (ds.Tables.Count > 0)
            {
                if (strSectionID != null && strCurrentPage != null)
                {
                    string strTrail = "Root ";
                    using (DataView bdView = new DataView(ds.Tables["PartCategory"]))
                    {
                        bdView.Sort = "PCName ASC";
                        strTrail += CatGetRows(bdView, strSectionID, 1, strPageName);
                    }
                    return strTrail;
                }
                else
                {
                    return "";
                }
            }
            else
            {
                return "Error, no data";

            }
        }
        catch
        {
            return "error with breadcrumbs function";
        }
    }

    private string CatGetRows(DataView dv, string strFilter, int intCurrentPage, string strPageName)
    {
        try
        {
            if (strFilter.Length > 0)
            {
                StringBuilder CatMenusb = new StringBuilder();
                dv.RowFilter = "PCpkey = " + strFilter + "";

                foreach (System.Data.DataRowView drv in dv)
                {
                    if (intCurrentPage == 1)
                    {
                        CatMenusb.Insert(0, " > " + drv["PCName"].ToString() + "");
                        intCurrentPage = 0;
                        CatMenusb.Insert(0, CatGetRows(dv, drv["ParentID"].ToString(), intCurrentPage, strPageName));
                    }
                    else
                    {
                        CatMenusb.Insert(0, " > " + drv["PCName"].ToString() + "");
                        CatMenusb.Insert(0, CatGetRows(dv, drv["ParentID"].ToString(), intCurrentPage, strPageName));
                    }
                }
                dv.Dispose();
                return CatMenusb.ToString();

            }
            else
            {
                return "";
            }
        }
        catch
        {
            return "error with CatGetRows function";
        }
    }
    // End Drop Down Category Menu Generator

    public string MakeCategoryMenu()
    {
        using (DataSet ds = new DataSet())
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
            {
                conn.Open();
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT PCpkey, ParentID, PCName FROM PartCategory ORDER BY PCName ASC", conn))
                {
                    da.FillSchema(ds, SchemaType.Source, "PartCategory");
                    da.Fill(ds, "PartCategory");
                }
            }

            StringBuilder sb = new StringBuilder();
            MakeJSON(0, sb, ds);
            return sb.ToString();
        }
    }

    public void MakeJSON(int pkey, StringBuilder sb, DataSet ds)
    {
        DataView dv = ds.Tables["PartCategory"].DefaultView;
        dv.Sort = "PCName ASC";
        dv.RowFilter = "ParentID = " + pkey;

        if (dv.Count > 0)
        {
            sb.Append("[" + Environment.NewLine);
            foreach (DataRowView drv in dv)
            {
                sb.Append("{\"title\": \"" + drv["PCName"].ToString() + "\", \"key\": \"" + drv["PCpkey"].ToString() + "\" , \"folder\": true");
               
                if (CheckChildren(Int32.Parse(drv["PCpkey"].ToString()), ds) > 0) {
                    sb.Append(", \"children\": ");
                    MakeJSON(Int32.Parse(drv["PCpkey"].ToString()), sb, ds);
                }
                sb.Append("},");
            }
            sb.Length--;

            sb.Append("]" + Environment.NewLine);
        }
    }

    public int CheckChildren(int pkey, DataSet ds)
    {
        using (DataView dv = new DataView(ds.Tables["PartCategory"]))
        {
            dv.RowFilter = "ParentID = " + pkey;
           return dv.Count;
           
        }
    }
    // Start Part Categories Tree List
    public string MakeTreeMenu(string LinkURL, string AddURL = null)
    {
        using (DataSet ds = new DataSet())
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
            {
                conn.Open();
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT PCpkey, ParentID, PCName FROM PartCategory ORDER BY PCName ASC", conn))
                {
                    da.FillSchema(ds, SchemaType.Source, "PartCategory");
                    da.Fill(ds, "PartCategory");
                }
            }

            StringBuilder sb = new StringBuilder();
            MakeNav(0, sb, ds, LinkURL, AddURL);
            
            return sb.ToString();
        }
    }

    public void  MakeNav(int pkey, StringBuilder sb, DataSet ds, string LinkURL, string AddURL = null)
    {
        DataView dv = ds.Tables["PartCategory"].DefaultView;
        dv.Sort = "PCName ASC";
        dv.RowFilter = "ParentID = " + pkey;

        if (dv.Count > 0)
        {
            sb.Append("<ul>" + Environment.NewLine);
            foreach (DataRowView drv in dv)
            {
                if (AddURL != null)
                {
                    sb.Append("<li><a href=\"" + LinkURL + drv["PCpkey"].ToString() + "\">" + drv["PCName"].ToString() + "</a> <a href=\"" + AddURL + drv["PCpkey"].ToString() + "\"><i class=\"small fa fa-fw fa-plus\"></i></a>");
                }
                else
                {
                    sb.Append("<li><a href=\"" + LinkURL + drv["PCpkey"].ToString() + "\">" + drv["PCName"].ToString() + "</a>");
                }
                MakeNav(Int32.Parse(drv["PCpkey"].ToString()), sb, ds, LinkURL, AddURL);
                sb.Append("</li>" + Environment.NewLine);
            }
            sb.Append("</ul>" + Environment.NewLine);
        }
    }
    // End Part Categories Tree List
}