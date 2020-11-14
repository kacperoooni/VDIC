virtual class shape;
	protected real width,height;
	
	function new(real w, real h);
		width = w;
		height = h;
	endfunction	
	
	function void get_area();
		$display("Can't get area of generic shape");
	endfunction
	
	pure virtual function void print();

endclass	

class rectangle extends shape;
	function new(real width, real height);
		super.new(width, height);
	endfunction	

	function real get_area();
		return width*height;
	endfunction
	
	function void print();
		$display("Rectangle w = %f, h = %f, area = %f", width,height,get_area());
	endfunction
endclass	

class triangle extends shape;
	function new(real width, real height);
		super.new(width, height);
	endfunction	

	function real get_area();
		return width*height/2;
	endfunction
	
	function void print();
		$display("Triangle w = %f, h = %f, area = %f", width,height,get_area());
	endfunction
endclass	
		
class square extends shape;
	function new(real height);
		super.new(height, height);
	endfunction	

	function real get_area();
		return height*height;
	endfunction
	
	function void print();
		$display("Square w = %f, area = %f", height,get_area());
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
	
class shape_reporter #(type T=shape);

   protected static T shape_storage[$];

   static function void queue_up_shape(T shape_t);
      shape_storage.push_back(shape_t);
   endfunction  

   static function void report_shapes();
	   real total_area;
      foreach (shape_storage[i]) begin
        shape_storage[i].print();
	      total_area = total_area + shape_storage[i].get_area();
      end
      $display("Total Area: %f",total_area);
   endfunction 

endclass 

	
module top;
	initial begin
		shape shape_h;
		triangle triangle_h;
		rectangle rect_h;
		square squ_h;
		int fd;
		string shape_type_file;
		real w,h;
		int status;
		fd = $fopen("./lab02part2A_shapes.txt","r");
		forever
			begin			
			status = $fscanf(fd,"%s %f %f", shape_type_file, w, h);
				if (status != 3) begin
					shape_reporter#(triangle)::report_shapes();
					shape_reporter#(square)::report_shapes();
					shape_reporter#(rectangle)::report_shapes();
					$finish;
					end
				case(shape_type_file)
					"rectangle":
						begin
							shape_h = shape_factory::make_shape(shape_type_file,w,h);
							$cast(rect_h,shape_h);		
							shape_reporter#(rectangle)::queue_up_shape(rect_h);	
						end
					"triangle":
						begin
							shape_h = shape_factory::make_shape(shape_type_file,w,h);
							$cast(triangle_h,shape_h);		
							shape_reporter#(triangle)::queue_up_shape(triangle_h);	
						end
					"square":
						begin
							shape_h = shape_factory::make_shape(shape_type_file,w,h);
							$cast(squ_h,shape_h);		
							shape_reporter#(square)::queue_up_shape(squ_h);	
						end
				endcase	
			end	
	end	
endmodule	