string="02:00.3 Serial bus controller [0c80]: NVIDIA Corporation Device 1ad7 (rev a1) 03:00.3 Serial bus controller [0c80]: NVIDIA Corporation Device 1ad7 (rev a1) 83:00.3 Serial bus controller [0c80]: NVIDIA Corporation Device 1ad7 (rev a1) 84:00.3 Serial bus controller [0c80]: NVIDIA Corporation Device 1ad7 (rev a1)"

print("lspci_count: ",string)


count=string.split("[")

print("count: ", len(count)-1)
