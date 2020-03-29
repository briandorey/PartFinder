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
/// Summary description for FootprintCategoryHelpers
/// </summary>
public class FootprintCategoryHelpers
{
  
    public FootprintCategoryHelpers()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    
    // Start Footprint Categories Tree List
    public string MakeFootprintTreeMenu(string LinkURL)
    {
        using (DataSet ds = new DataSet())
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
            {
                conn.Open();
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT FCPkey, ParentCategory, FCName FROM FootprintCategory ORDER BY FCName ASC", conn))
                {
                    da.FillSchema(ds, SchemaType.Source, "FootprintCategory");
                    da.Fill(ds, "FootprintCategory");
                }
            }

            StringBuilder sb = new StringBuilder();
            MakeFootprintNav(0, sb, ds, LinkURL);


            return sb.ToString();
        }
    }

    public void MakeFootprintNav(int pkey, StringBuilder sb, DataSet ds, string LinkURL)
    {
        DataView dv = ds.Tables["FootprintCategory"].DefaultView;
        dv.Sort = "FCName ASC";
        dv.RowFilter = "ParentCategory = " + pkey;

        if (dv.Count > 0)
        {
            sb.Append("<ul>" + Environment.NewLine);
            foreach (DataRowView drv in dv)
            {
                sb.Append("<li><a href=\"" + LinkURL + drv["FCPkey"].ToString() + "\">" + drv["FCName"].ToString() + "</a>");

                MakeFootprintNav(Int32.Parse(drv["FCPkey"].ToString()), sb, ds, LinkURL);
                sb.Append("</li>" + Environment.NewLine);
            }
            sb.Append("</ul>" + Environment.NewLine);
        }
    }
    // End Footprint Categories Tree List

    // Start Drop Down Footprint Category Menu Generator
    public void LoadFootprintMenu(DropDownList menu, bool IncludeRoot)
    {
        using (DataSet ds = new DataSet())
        {
            if (IncludeRoot) { 
            menu.Items.Add(new ListItem("Root", "0"));
            }
            using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
            {
                connection.Open();
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT FCPkey, ParentCategory, FCName FROM FootprintCategory ORDER BY FCName ASC", connection))
                {
                    da.FillSchema(ds, SchemaType.Source, "FootprintCategory");
                    da.Fill(ds, "FootprintCategory");
                }
                FootprintCatMenuSubRepeater("0", menu, ds);
            }
        }
    }

    private void FootprintCatMenuSubRepeater(string CatID, DropDownList menu, DataSet ds)
    {
        DataView dv = new DataView
        {
            Table = ds.Tables["FootprintCategory"],
            RowFilter = "ParentCategory = " + CatID,

            Sort = "FCName ASC"
        };
        foreach (System.Data.DataRowView drv in dv)
        {
            menu.Items.Add(new ListItem(FootprintCatSecMenuBuilder(drv["FCPkey"].ToString(), drv["FCName"].ToString(), "", ds), drv["FCPkey"].ToString()));

            FootprintCatMenuSubRepeater(drv["FCPkey"].ToString(), menu, ds);
        }
    }

    private string FootprintCatSecMenuBuilder(string strSectionID, string strCurrentPage, string strPageName, DataSet ds)
    {
        try
        {
            if (ds.Tables.Count > 0)
            {
                if (strSectionID != null && strCurrentPage != null)
                {
                    string strTrail = "Root ";
                    using (DataView bdView = new DataView(ds.Tables["FootprintCategory"]))
                    {
                        bdView.Sort = "FCName ASC";
                        strTrail += FootprintCatGetRows(bdView, strSectionID, 1, strPageName);
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

    private string FootprintCatGetRows(System.Data.DataView dv, string strFilter, int intCurrentPage, string strPageName)
    {
        try
        {
            if (strFilter.Length > 0)
            {
                StringBuilder CatMenusb = new StringBuilder();
                dv.RowFilter = "FCPkey = " + strFilter + "";

                foreach (System.Data.DataRowView drv in dv)
                {
                    if (intCurrentPage == 1)
                    {
                        CatMenusb.Insert(0, " > " + drv["FCName"].ToString() + "");
                        intCurrentPage = 0;
                        CatMenusb.Insert(0, FootprintCatGetRows(dv, drv["ParentCategory"].ToString(), intCurrentPage, strPageName));
                    }
                    else
                    {
                        CatMenusb.Insert(0, " > " + drv["FCName"].ToString() + "");
                        CatMenusb.Insert(0, FootprintCatGetRows(dv, drv["ParentCategory"].ToString(), intCurrentPage, strPageName));
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
    // End Drop Down Footprint Category Menu Generator
}
