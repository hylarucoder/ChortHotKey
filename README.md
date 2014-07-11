MyAHK
=====

some AHK Script （一些常用的AHK脚本）

安装需要注意安装autohotkey_L
这个版本需要注意用记事本或者scie这个编辑器，但是我推荐使用sublimeText3来写，原因是优雅啊！经过配置以后简直是神器。当然，用sublime来写AHK的时候记得要保存的时候编码保存UTF-8 with BOM。

现在编写分为三个部分：
MyAHK文件夹中暂时定为
lib\Constant.ahk —— 负责存放一程序位置，常用变量，常用网址，常用文件夹地址等等
lib\func.ahk —— 负责比较稍微有点复杂（其实一点都不复杂）的操作，已经封装成函数
MyScript.ahk —— 主文件，用于调用各类型函数
