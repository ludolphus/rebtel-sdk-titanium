#!/usr/bin/env python

import os, sys, urllib2, shutil, tarfile, re, argparse

# project root
proot = os.path.abspath(os.path.dirname(sys._getframe(0).f_code.co_filename))

def log_i(msg):
    print "[INFO] " + msg

def download_rebtel_sdk(url, dst_path):
    package_name = os.path.basename(url)
    inf = urllib2.urlopen(url, timeout=10)

    if os.path.exists(dst_path):
        log_i("File already exists at %s (skipping download...)" % dst_path)
        return

    log_i("Downloading '%s' to '%s'" % (url, dst_path))
    
    with open(dst_path,'wb') as outf:
        shutil.copyfileobj(inf, outf)

    if os.stat(dst_path).st_size <= 0:
        raise Error("Failed to download '%s' to '%s'" % (url, dst_path))

def extract_revision_from_url(url):
    pattern = "(.*)-([1-9]\.[0-9]\.[0-9])-([a-z0-9]{4,40})\.tar\.bz2$"
    m = re.match(re.compile(pattern), url)
    if m and len(m.groups()) == 3:
        return (m.group(2), m.group(3))
    else:
        raise Exception("Could not extract version from url '%s'" % url)

def verify_version_file(sdk_path, expected_version, expected_revision):
    version_file = os.path.join(sdk_path, "VERSION")

    if not os.path.exists(version_file):
        raise Exception("Could not find VERSION file at '%s'" %  version_file)

    lines = open(version_file, 'r').read().split("\n")

    mv = re.match(re.compile("^Version: ([0-9\.]{1,10})$"), lines[0])
    mr = re.match(re.compile("^Revision: (.*)$"), lines[1])

    if not (mv and mr):
        raise Exception("Could not read VERSION file")

    if not (mv.group(1) == expected_version) and (mr.group(1) == expected_revision):
      raise Exception("SDK version mismatch. Please clean out any previously downloaded files")

    log_i("Found existing Rebtel SDK (version: %s, rev: %s) in '%s'" % (expected_version, 
                                                                        expected_revision,
                                                                        sdk_path))

def check_for_existing_package(dst_path, expect_match_download_url):

    (version, rev)  = extract_revision_from_url(expect_match_download_url)

    sdk_path = os.path.join(dst_path, "RebtelSDK")

    if not os.path.exists(sdk_path):
        return False
    
    verify_version_file(sdk_path, version, rev)
    
    return True

def unpack_sdk_package(tar_path, dst_path):
    if not tarfile.is_tarfile(tar_path):
        raise Error('Unable to read package file %s' % tar_path)
    log_i("Extracting '%s' to '%s'" % (tar_path, dst_path))
    tar = tarfile.open(tar_path, 'r:bz2')
    tar.extractall(dst_path)

def copy_static_lib(sdk_path, dst_path):
    lib_path = os.path.realpath(os.path.join(sdk_path, "RebtelSDK.framework", "RebtelSDK"))
    dst_lib_path =  os.path.join(dst_path, "libRebtelSDK.a")
    log_i("Copying library file from RebtelSDK.framework to '%s'" % dst_lib_path)
    shutil.copyfile(lib_path, dst_lib_path)

def prepare(rebtel_sdk_download_url):
    package_name = os.path.basename(rebtel_sdk_download_url)

    if not check_for_existing_package(os.path.join(proot, "vendor"), rebtel_sdk_download_url):
        package_path = os.path.join(proot, "vendor", package_name)
        download_rebtel_sdk(rebtel_sdk_download_url, package_path)
        unpack_sdk_package(package_path, os.path.join(proot, "vendor"))
        copy_static_lib(os.path.join(proot, "vendor", "RebtelSDK"), os.path.join(proot, "lib"))
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--rebtel-sdk-url', required=True)
    args = parser.parse_args()
    prepare(args.rebtel_sdk_url)
    
    
    
