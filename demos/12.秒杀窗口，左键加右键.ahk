~LButton & RButton::
        ; ��ס���� A ���ٰ� B ����д���� ��A & B������Ŀ�������дŶ����Ŀ���ʵ�������Ŀ�ݼ�������~����������ָʾԭ�е������Ҫ���������ӡ�~���������ʧЧ�ˡ�
WinGetClass, class, A
        ; ��������ר�ŶԸ� Gtalk �ġ���õ�ǰ����ڣ����� A �������Ǵ���ǰ����ڣ����ࣨclass����������ֵ�� class����������ʺ�רҵ����GTalk �����촰�ڵı�����û�й��ɵģ������Ƕ���ͬһ�࣬���������� Chat View���ñ�����˵�����Ƕ���ͬһ�����ࡱ�����Ƕ������࣬��������ֿ���ϸ��Ϊ�ܶࡰ�ࡱ��
IfInString, class, Chat
        ; �ж� class ���Ƿ��� chat
{
send !{F4}
return
        ; �еĻ���˵���ܿ��ܣ�99.9%���� Gtalk �����촰���������� Alt + F4 �ر����촰�ڡ����ҽ����ű���
}
WinGetActiveTitle, Title
        ; ��ȡ��ǰ����ڵı��⣬��ֵ�� Title
IfInString, Title, Firefox
        ; �ж� Title ���Ƿ��� Firefox ���������Ǵ�ʲô��ҳ���������Զ����ģ���Ҳ�����������������жϡ���ĩ�������ô���һ�����ڵ�������
{
send ^w
return
}
IfInString, Title, AutoHotkey
{
send {esc}
return
}
else
        ; ��� else �Ƕ���ģ���ʷ�������⡣orz
WinClose, %Title%
return

