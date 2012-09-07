<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<html>
<jsp:include page="../menu/header.jsp" />
<jsp:include page="../menu/includescripts.jsp" />

<body>
	<jsp:include page="../menu/menu.jsp" />
	<hr class="soften">
	
	<div class="container">
		<div id="form"></div>
	</div>
</body>

<script>
Ext.onReady(function() 
{
	Ext.QuickTips.init();
	Ext.define('ProductGroup', 
	{
		extend : 'Ext.data.Model',
		fields : 
		[
			{name: 'id', mapping: 'id'}, {name: 'groupName', mapping: 'groupName'}, {name: 'description', mapping: 'description'}
		]
	});
				
	var productGroupStore = Ext.create('Ext.data.Store', 
	{
		model : 'ProductGroup', autoLoad : true, remoteFilter : 'true', remoteSort : 'true',
		proxy : 
		{	type : 'ajax',
			api : { read : '<c:url value="/productgroup/list"/>' },
			reader : { type : 'json', root : 'data', successProperty : 'success' },
			listeners : 
			{
				exception : function(proxy, response, operation) 
				{
					Ext.MessageBox.show(
					{
						title : 'REMOTE EXCEPTION', msg : operation.getError(), icon : Ext.MessageBox.ERROR, buttons : Ext.Msg.OK
					});
				}
			}
		}
	});
	var productDetailsTab = Ext.create('Ext.form.Panel',
	{
		bodyStyle:'padding:5px', labelWidth : 80, monitorValid : true, border:false, fieldDefaults: { labelAlign: 'left', msgTarget: 'side' },
		defaults: { anchor: '100%' }, url : '<c:url value="/product/update" />',
		items : 
		[
			{ 	title: 'Product Details', layout:'column', bodyStyle:'padding:10px', border:false,
				items:
				[ 
					{ 	border:false, layout: 'anchor', defaultType: 'textfield', 
						items: 
						[
							{ 	fieldLabel: 'Product Name', name : 'productName', value : '<c:out value="${productBean.productName}" />', anchor:'95%', allowBlank : false, readOnly: true }, 
							{ 	fieldLabel: 'Description', name : 'description', value : '<c:out value="${productBean.description}" />', anchor:'95%', allowBlank : false },
							{ 	fieldLabel: 'Product Group', name : 'productGroup', value : '<c:out value="${productBean.productGroup}" />', anchor:'95%', xtype: 'combobox', allowBlank : false, 
								store: productGroupStore, displayField: 'groupName'
							},
							{ fieldLabel: 'Price', name : 'price', value : '<c:out value="${productBean.price}" />', anchor:'95%', allowBlank : false }
						]
					}
				]
			}
		],
		buttons : 
		[
			{ text : 'Save', formBind : true, handler : function() { productDetailsSubmit(); } }, 
			{ text : 'Cancel', handler: function() { window.location = "<c:url value="/product"/>" ;} } 
		], buttonAlign : 'left'
	});
		
	var tabPanel = new Ext.FormPanel( 
	{
		bodyStyle:'padding:5px', border:false, fieldDefaults: { labelAlign: 'left', msgTarget: 'side' }, defaults: { anchor: '100%' },
		items: 
		[
	       	{ 	xtype:'tabpanel', plain:true, activeTab: 0, defaults:{bodyStyle:'padding:10px'},
	            items:
				[
					{ 	title: '<c:out value="${productBean.productName}" />', defaultType: 'textfield', items: [productDetailsTab] },
					{	title:'Purchase Hisory', defaultType: 'textfield', items: [] }
				]
	        }
		]
	});
		
	function productDetailsSubmit()
	{
		productDetailsTab.getForm().submit(
		{
			success : function(form, action) 
			{
				Ext.Msg.alert('Success', action.result.message);
			},
			failure : function(form, action) 
			{
				Ext.Msg.alert('Warning', action.result.message);
			}
		});
	}
		
	tabPanel.render("form");
});
</script>

</html>