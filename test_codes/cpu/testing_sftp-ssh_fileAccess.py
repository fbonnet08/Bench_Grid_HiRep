import paramiko

# Define connection parameters
hostname = "login.vega.izum.si"
username = "eufredericb"
password = "password"          # Avoid hardcoding passwords; use a secure method
remote_path = "/ceph/hpc/home/eufredericb/SwanSea/SourceCodes/LatticeRuns/BKeeper_run_gpu/small/Run_BKeeper_run_gpu_lat24.24.24.32_nodes001_mpi01-01-04-01_small/Run_BKeeper_run_gpu_lat24.24.24.32_nodes001_mpi01-01-04-01_small.out"

# Establish SFTP connection
try:
    # ssh access
    ssh = paramiko.SSHClient()

    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    ssh.connect(hostname, username=username,
                password='<password>',
                key_filename='C:\cygwin64\home\Frederic\.ssh\id_ed25519.pub')

    stdin, stdout, stderr = ssh.exec_command('ls')
    print(stdout.readlines())
    ssh.close()

    # sftp access
    transport = paramiko.Transport((hostname, 22))
    transport.connect(username=username, password=password)

    sftp = paramiko.SFTPClient.from_transport(transport)

    # Read and print file contents
    with sftp.open(remote_path, 'r') as file:
        content = file.read()
        print(content)

    # Close connection
    sftp.close()
    transport.close()

except Exception as e:
    print(f"Error: {e}")