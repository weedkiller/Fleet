using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using BWA.BFP.Data;
using BWA.BFP.Core;

namespace BWA.BFP.Web.error
{
	public class _error_report_detail : BFPPage
	{
		protected System.Web.UI.WebControls.Label lblPageName;
		protected System.Web.UI.WebControls.Label lblUserName;
		protected System.Web.UI.WebControls.Label lblOrg;
		protected System.Web.UI.WebControls.Label lblCreated;
		protected System.Web.UI.WebControls.Label lblDesc;
		protected System.Web.UI.WebControls.Label lblErrorMessage;
		protected BWA.BFP.Web.Controls.User.Header Header;

		private int ErrorId;
		protected System.Web.UI.WebControls.Label lblBack;
		private clsErrors error = null;

		private void Page_Load(object sender, System.EventArgs e)
		{
			try
			{
				if(Request.QueryString["id"] == null)
				{
					Session["lastpage"] = "error_report.aspx";
					Session["error"] = _functions.ErrorMessage(104);
					Response.Redirect("error.aspx", false);
					return;
				}
				try
				{
					ErrorId=Convert.ToInt32(Request.QueryString["id"]);
				}
				catch(FormatException fex)
				{
					Session["lastpage"] = "error_report.aspx";
					Session["error"] = _functions.ErrorMessage(105);
					Response.Redirect("error.aspx", false);
					return;
				}

				string [,] arrBrdCrumbs = new string [2,2];
				arrBrdCrumbs[0,0]="main.aspx";
				arrBrdCrumbs[0,1]="Home";
				arrBrdCrumbs[1,0]="error_report.aspx";
				arrBrdCrumbs[1,1]="Error report";
				PageTitle = "Error Detail";
				Header.BrdCrumbs=ParseBreadCrumbs(arrBrdCrumbs,PageTitle);
				Header.PageTitle=PageTitle;
				lblBack.Text = "<input type=button value=\" Back \" onclick=\"document.location='error_report.aspx'\">";
				if(!IsPostBack)
				{
					error = new clsErrors();
					error.cAction = "S";
					error.iId = ErrorId;
					if(error.ErrorDetail() != -1)
					{
						lblCreated.Text = error.daCreated.Value.ToString("g");
						lblDesc.Text = error.sDesc.Value;
						lblErrorMessage.Text = error.sErrorName.Value;
						lblOrg.Text = error.sOrgName.Value;
						lblPageName.Text = error.sPageName.Value;
						lblUserName.Text = error.sUserName.Value;
					}
					else
					{
						Session["lastpage"] = ParentPageURL;
						Session["error"] = _functions.ErrorMessage(115);
						Response.Redirect("error.aspx", false);
					}

				}
			}
			catch(Exception ex)
			{
				_functions.Log(ex, HttpContext.Current.User.Identity.Name, "error_report.aspx.cs");
				Session["lastpage"] = ParentPageURL;
				Session["error"] = ex.Message;
				Session["error_report"] = ex.ToString();
				Response.Redirect("error.aspx", false);
			}
			finally
			{
				if(error != null)
				{
					error.Dispose();
				}
			}

		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			InitializeComponent();
			base.OnInit(e);
			base.CheckLinks(this.Page);
		}
		
		private void InitializeComponent()
		{    
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion
	}
}
