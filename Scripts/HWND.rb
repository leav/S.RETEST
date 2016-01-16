#encoding:utf-8
#==============================================================================
# [XP/VX] 精确获取窗口句柄 by 紫苏
#==============================================================================
# ■ Kernel
#==============================================================================
module HWND
  #--------------------------------------------------------------------------
  # ● 需要的 Windows API 函数
  #--------------------------------------------------------------------------
  GetWindowThreadProcessId = Win32API.new("user32", "GetWindowThreadProcessId", "LP", "L")
  GetWindow = Win32API.new("user32", "GetWindow", "LL", "L")
  GetClassName = Win32API.new("user32", "GetClassName", "LPL", "L")
  GetCurrentThreadId = Win32API.new("kernel32", "GetCurrentThreadId", "V", "L")
  GetForegroundWindow = Win32API.new("user32", "GetForegroundWindow", "V", "L")
  SetForegroundWindow = Win32API.new("user32", "SetForegroundWindow", "L", "L")
  
  module_function
  #--------------------------------------------------------------------------
  # ● 通过窗口类获取窗口句柄
  #--------------------------------------------------------------------------
  def get_thread_hwnd(class_name)
    # 获取调用线程（RM 的主线程）的进程标识
    threadID = GetCurrentThreadId.call
    # 获取 Z 次序中最靠前的窗口
    hWnd = GetWindow.call(GetForegroundWindow.call, 0)
    # 枚举所有窗口
    while hWnd != 0
      # 如果创建该窗口的线程标识匹配本线程标识
      if threadID == GetWindowThreadProcessId.call(hWnd, 0)
        # 分配一个 11 个字节的缓冲区
        className = " " * 11
        # 获取该窗口的类名
        GetClassName.call(hWnd, className, 12)
        # 如果匹配 class_name 则跳出循环
        break if className == class_name
      end
      # 获取下一个窗口
      hWnd = GetWindow.call(hWnd, 2)
    end
    return hWnd
  end
  #--------------------------------------------------------------------------
  # ● 获取窗口句柄
  #--------------------------------------------------------------------------
  def get_hwnd
    return get_thread_hwnd("RGSS Player")
  end
  #--------------------------------------------------------------------------
  # ● 获取DEBUG窗口句柄
  #--------------------------------------------------------------------------
  def get_console_hwnd
    return get_thread_hwnd("ConsoleWind")
  end
  #--------------------------------------------------------------------------
  # ● 激活游戏窗口
  #--------------------------------------------------------------------------
  def foreground_game
    SetForegroundWindow.call(get_hwnd)
  end
  #--------------------------------------------------------------------------
  # ● 激活DEBUG窗口
  #--------------------------------------------------------------------------
  def foreground_console
    SetForegroundWindow.call(get_console_hwnd)
  end
end