virtual class shape;
	protected int width,height;
	
	function new(int w, int h);
		width = w;
		height = h;
	endfunction	
	
	function void get_area();
		$display("Can't get area of generic shape");
	endfunction
	
	function void print();
		$display("Generic shape");
	endfunction	
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
		
module top;
	initial begin
		rectangle rect_o;
		rect_o = new(5,6);
		rect_o.print();
	end	
endmodule	