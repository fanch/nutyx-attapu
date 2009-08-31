# Begin /etc/profile.d/jdk.sh
export J2SDKDIR=/opt/jdk

# Set JAVA_HOME directory
JAVA_HOME=/opt/jdk

# Adjust PATH
pathappend ${JAVA_HOME}/bin PATH

# Auto Java CLASSPATH
# Copy jar files to, or create symlinks in this directory
AUTO_CLASSPATH_DIR=/usr/lib/classpath
pathprepend . CLASSPATH
for dir in `find ${AUTO_CLASSPATH_DIR} -type d 2>/dev/null`; do
    pathappend $dir CLASSPATH
done

export JAVA_HOME CLASSPATH
unset AUTO_CLASSPATH_DIR
unset dir

# End /etc/profile.d/jdk.sh
