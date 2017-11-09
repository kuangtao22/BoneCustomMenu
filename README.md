# BoneCustomMenu 自定义菜单栏
![github](https://github.com/kuangtao22/BoneCustomMenu/blob/master/%E9%A2%84%E8%A7%88.gif
 "github")  
## 简介
BoneCustomMenu是纯swift写的可自定义菜单栏，可以设置单列，双列，筛选，选中等，当菜单栏按钮超过4个时，可左右拖动

#### 

	

## 环境要求

* iOS 7.0+
* Xcode 8 (Swift 3) 版

## BoneCustomMenu
* 使用方法

		menuView = BoneCustomMenu(top: 200, height: 40)
		menuView.delegate = self
		self.view.addSubview(menuView)
		menuView.reloadData()

* 属性设置

		BoneCustomPopup.Size	可设置表格大小，字体大小
		BoneCustomPopup.Color	// 可设置字体颜色，分割线颜色

--

* 代理协议(参考了UITableView的代理方式)
    
--  

		/// boneMenu 常规 点击事件
   		///
   		/// - Parameters:
    	///   - menu:
    	///   - indexPath:
    	/// - Returns:
    	func boneMenu(_ menu: BoneCustomMenu, didSelectRowAtIndexPath indexPath: BoneCustomPopup.IndexPath)
    
--  

    	/// boneMenu filter 点击事件(如果没有筛选可实现)
    	///
    	/// - Parameters:
    	///   - menu:
    	///   - indexPath:
    	/// - Returns:
    	func boneMenu(_ menu: BoneCustomMenu, didSelectRowAtColumn column: Int, filterDatas: [[Int]])
    
--  

    	/// 返回 boneMenu 有多少列 ，默认1列
    	///
    	/// - Parameter menu
    	/// - Returns
    	func numberOfColumns(_ menu: BoneCustomMenu) -> Int
    
--  

    	/// 返回 boneMenu 第column列有多少行
    	///
    	/// - Parameters:
    	///   - menu:
    	///   - column:
    	/// - Returns:
    	func boneMenu(_ menu: BoneCustomMenu, numberOfSectionsInColumn column: Int) -> Int
    
--  

    	/// 返回 boneMenu 第column列section区有多少行
    	///
    	/// - Parameters:
   	 	///   - menu:
    	///   - column:
    	///   - section:
    	/// - Returns: 二级列表行数
    	func boneMenu(_ menu: BoneCustomMenu, numberOfRowsInSections indexPath: BoneCustomPopup.IndexPath) -> Int
    
--  

    	/// 返回 boneMenu column类型
    	///
    	/// - Parameters:
    	///   - menu:
    	///   - column:
    	/// - Returns:
    	func boneMenu(_ menu: BoneCustomMenu, typeForColumnAt column: Int) -> BoneCustomPopup.ColumnInfo
    
--  

    	/// 返回 boneMenu section标题
    	///
    	/// - Parameters:
    	///   - menu:
    	///   - column:
    	///   - section:
    	/// - Returns:
    	func boneMenu(_ menu: BoneCustomMenu, titleForSectionAt indexPath: BoneCustomPopup.IndexPath) -> String
    
--  

    	/// 返回 boneMenu row标题
    	///
    	/// - Parameters:
    	///   - menu:
    	///   - indexPath:
    	/// - Returns:
   	 	func boneMenu(_ menu: BoneCustomMenu, titleForRowAt indexPath: BoneCustomPopup.IndexPath) -> String
    
--  

    	/// 返回 boneMenu filter section选择类型(如果没有筛选可实现)
    	///
    	/// - Parameters:
    	///   - menu:
    	///   - indexPath:
    	/// - Returns: 多选/单选
    	func boneMenu(_ menu: BoneCustomMenu, filterDidForSectionAt indexPath: BoneCustomPopup.IndexPath) -> BoneCustomPopup.FilterType?