=begin

InputFocus
Author: leav

���ܣ�
���ʹ��Input�Ķ���֮�����ϣ���ÿ����������Լ��Ľ��㣬
������֪����������ļ������

Ӧ�ã�
����UI�����ӵĻ��ص�

=end

module Input
  class << self
    #--------------------------------------------------------------------------
    # �� ���ؽ����ջ
    #--------------------------------------------------------------------------
    def get_focus_stack
      return @focus_stack || @focus_stack = []
    end
    #--------------------------------------------------------------------------
    # �� ����object�Ƿ��ڽ���
    #--------------------------------------------------------------------------
    def focus?(object)
      focus = self.get_focus_stack.last
      return focus == nil || focus == object
    end
    #--------------------------------------------------------------------------
    # �� ����object
    #--------------------------------------------------------------------------
    def focus(object)
      raise "Input.focus() cannot have nil parameter" if object == nil
      unfocus(object)
      get_focus_stack.push(object)
    end
    #--------------------------------------------------------------------------
    # �� ȡ��object����
    #--------------------------------------------------------------------------
    def unfocus(object)
      raise "Input.unfocus() cannot have nil parameter" if object == nil
      get_focus_stack.reject! do |item|
        item == object
      end
    end
    #--------------------------------------------------------------------------
    # �� �ض���Input����
    #    Inputֻ��Դ��ڽ���Ķ�������Ӧ
    #--------------------------------------------------------------------------    
    if @input_focus_old_defined == nil
      %w[press? trigger? repeat?].each do |symbol|
        eval("
          alias :input_focus_old_#{symbol} :#{symbol}
          def #{symbol}(key, object = nil)
            if focus?(object)
              return input_focus_old_#{symbol}(key)
            else
              return false
            end
          end
        ")
      end
      %w[dir4 dir8].each do |symbol|
        eval("
          alias :input_focus_old_#{symbol}  :#{symbol}
          def #{symbol}(object = nil)
            if focus?(object)
              return input_focus_old_#{symbol}()
            else
              return 0
            end
          end
        ")
      end
      @input_focus_old_defined = true
    end
  end
end