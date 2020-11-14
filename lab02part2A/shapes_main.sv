virtual class shape;
	protected int width,height;
	
	function new(int w, int h);
		width = w;
		height = h;
	endfunction	
	
	function void get_area();
		$display("Can't get area of generic shape");
	endfunction
	
	pure virtual function void print();

endclass	

class rectangle extends shape;
	function new(int width, int height);
		super.new(width, height);
	endfunction	

	function int get_area();
		return width*height;
	endfunction
	
	function void print();
		$display("w = %d, h = %d, area = %d", width,height,get_area());
	endfunction
endclass	

class triangle extends shape;
	function new(int width, int height);
		super.new(width, height);
	endfunction	

	function int get_area();
		return width*height/2;
	endfunction
	
	function void print();
		$display("w = %d, h = %d, area = %d", width,height,get_area());
	endfunction
endclass	
		
class square extends shape;
	function new(int height);
		super.new(height, height);
	endfunction	

	function int get_area();
		return height*height;
	endfunction
	
	function void print();
		$display("w = %d, area = %d", height,get_area());
	endfunction
endclass	

class shape_factory;
	static function shape make_shape (string shape_type, real w, real h);
		rectangle rect_h;
		triangle trian_h;
		square squ_h;
		case(shape_type)
			"rectangle":
				begin
					rect_h = new(w,h);
					return rect_h;
				end	
			"triangle":
				begin
					trian_h = new(w,h);
					return trian_h;
				end	
			"square":
				begin
					squ_h = new(w);
					return squ_h;
				end	
			default:
				$error("No such shape");
		endcase
	endfunction
endclass	
module top;
	initial begin
		shape shape_h;
		shape_h = shape_factory::make_shape("triangle",2,3);
		shape_h.print();
	end	
endmodule	