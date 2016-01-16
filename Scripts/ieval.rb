#encoding:utf-8
#==============================================================================
# ■ IEval v0.9
#------------------------------------------------------------------------------
# 　读作：山寨irb
#   使用：
#   - VA的情况下，确保使用控制台（VA编辑器菜单-测试-显示主控制台）
#   - 调用ieval(binding)然后在控制台输入需要eval的指令
#   - 例如在scene的update方法中加入 ieval(binding) if $TEST && Input.trigger?(:F5)
#   特点：
#   - 可以分多行输入
#   - 输入空行的话结束本次ieval调用
#   - 临时变量全局保存，每次ieval均能获取之前设定的临时变量
#   - 总之就是可以在RGSS上跑的弱化版irb
#==============================================================================

require "Scripts/HWND"

module IEval
  #--------------------------------------------------------------------------
  # ● ieval
  #--------------------------------------------------------------------------
  def ieval(bind)
    HWND.foreground_console
    # 载入保存的临时变量
    prescript = ''
    IEval.locals.each_key{|var| prescript << var.to_s + "= IEval.locals[:#{var}]\n"}
    eval(prescript, bind)
    # 开始ieval
    script = ''
    while true
      print "ieval> "
      line = gets
      # ieval结束
      if !line || line.strip.empty?
        print "ieval end\n"
        # 保存临时变量
        eval("local_variables.each{|var| IEval.locals[var] = eval(var.to_s)}", bind)
        return
      # 运行输入的内容
      else
        script << line
        begin
          print "=> #{eval(script, bind)}\n"
          script.clear
        rescue SyntaxError => e
        rescue Exception => e
          p e
          script.clear
        end
      end
    end
    HWND.foreground_game
  end
  #--------------------------------------------------------------------------
  # ● eval局域临时变量保存
  #--------------------------------------------------------------------------
  @@locals = {}
  def self.locals
    return @@locals
  end
  #--------------------------------------------------------------------------
  # ● 测试
  #--------------------------------------------------------------------------
  def self.test
    loop do
      p "=== another call to ieval ==="
      ieval(binding)
    end
  end
end

include IEval

if $TEST
  Thread.new do
    p "IEval started"
    loop do
      if Input.press?(:F5)
        ieval(binding)
      end
      sleep(0.1)
    end
  end
end

