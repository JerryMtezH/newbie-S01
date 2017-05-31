def prism_type(*sides)
	sides.uniq.count == 1 ? "cubo" : sides.uniq.count == 2 ? "prisma rectangular" : "cuboide"
end
p prism_type(5, 5, 5) == "cubo"
p prism_type(5, 5, 4) == "prisma rectangular"
p prism_type(5, 4, 3) == "cuboide"
p prism_type(10, 8, 2) == "cuboide"