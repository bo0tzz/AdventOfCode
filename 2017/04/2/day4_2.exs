String.split(File.read!("in.txt"), "\n") # Read input per line
|> Enum.map(&String.split(&1, "\s")) # Split each line on spaces
|> Enum.map(fn (line) -> (
    line |> Enum.map(&(
        String.to_charlist(&1) |> Enum.sort) # Sort the characters in each word
      ))
  end)
# If a set with all the words on the line is of a different size,
# then some words were not unique. Count the times when sizes are equal
|> Enum.count(&((Enum.count(&1)) == (MapSet.size(MapSet.new(&1)))))
|> Kernel.-(1) # Newline at the end of the input file is counted; let's not
|> IO.puts # Print out final value
