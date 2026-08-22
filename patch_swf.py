import zlib
import sys


def patch_swf(input_file, output_file):
  try:
    with open(input_file, "rb") as f:
      data = f.read()


  except FileNotFoundError:
    print(f"Error: Could not find {input_file}")
    return

  # Check SWF signature (first 3 bytes)
  signature = data[:3]

  # In SWF files, Tag 9 (SetBackgroundColor) with a length of 3 bytes (RGB)
  # is represented by the little-endian header 0x0243, followed by the color.
  # White = 43 02 FF FF FF
  # Black = 43 02 00 00 00
  white_bg_tag = b"\x43\x02\xff\xff\xff"
  black_bg_tag = b"\x43\x02\x00\x00\x00"

  if signature == b"CWS":
    print("Compressed SWF detected. Decompressing...")
    header = data[:8]
    compressed_body = data[8:]

    try:
      uncompressed_body = zlib.decompress(compressed_body)

    except zlib.error:
      print("Error decompressing SWF data.")
      return

    if white_bg_tag not in uncompressed_body:
      print("White background tag not found. It might already be a different color.")
      return

    print("Patching background color to black...")
    patched_body = uncompressed_body.replace(white_bg_tag, black_bg_tag)

    # Recompress the modified body
    new_compressed_body = zlib.compress(patched_body)
    new_data = b"CWS" + header[3:8] + new_compressed_body

  elif signature == b"FWS":
    print("Uncompressed SWF detected.")
    if white_bg_tag not in data:
      print("White background tag not found.")
      return

    print("Patching background color to black...")
    new_data = data.replace(white_bg_tag, black_bg_tag)

  else:
    print("Error: Not a valid SWF file.")
    return

  # Save the patched file
  with open(output_file, "wb") as f:
    f.write(new_data)

  print(f"Success! Patched file saved as {output_file}")


if __name__ == "__main__":
  if len(sys.argv) != 3:
    print("Usage: python patch_swf.py <input.swf> <output.swf>")
  else:
    patch_swf(sys.argv[1], sys.argv[2])

