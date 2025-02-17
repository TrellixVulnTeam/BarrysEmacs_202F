#
#   list_repo.py
#
import sys
import xml.dom.minidom
import gzip

def listRepo( repo_url ):
    from urllib.request import urlopen
    from urllib.error import HTTPError

    #
    #   Fetch repomd
    #
    try:
        with urlopen( '%s/repodata/repomd.xml' % (repo_url,) ) as req:
            repomd = req.read()
    except HTTPError as e:
        print('Error: %s - %s' % (repo_url, e))
        return {}

    dom = xml.dom.minidom.parseString( repomd )
    for data_element in dom.getElementsByTagName( 'data' ):
        data_type = data_element.getAttribute( 'type' )
        if data_type != 'primary':
            continue

        primary_href = getOnlyElement( data_element, 'location' ).getAttribute( 'href' )

    #
    #   Fetch primary
    #
    with urlopen( '%s/%s' % (repo_url, primary_href) ) as req:
        primary = req.read()

    packages = {}

    dom = xml.dom.minidom.parseString( gzip.decompress( primary ) )
    for package_element in dom.getElementsByTagName( 'package' ):
        package_type = package_element.getAttribute( 'type' )
        if package_type != 'rpm':
            continue

        name = getElementText( getOnlyElement( package_element, 'name' ) )
        version_element = getOnlyElement( package_element, 'version' )
        ver = version_element.getAttribute( 'ver' )
        rel = version_element.getAttribute( 'rel' )

        version_element = getOnlyElement( package_element, 'time' )
        build_time = version_element.getAttribute( 'build' )

        packages[ name ] = (ver, rel, float(build_time))

    return packages

def getOnlyElement( element, tag ):
    all_children = element.getElementsByTagName( tag )
    assert len(all_children) == 1
    return all_children[0]

def getElementText( element ):
    text = []
    for node in element.childNodes:
        if node.nodeType == node.TEXT_NODE:
            text.append( node.data )

    return ''.join( text )

def unittest( argv ):
    all_packages = listRepo( argv[1] )

    for name in sorted( all_packages.keys() ):
        ver, rel, build_time = all_packages[ name ]
        print( '%s: %s-%s' % (name, ver, rel) )

    return 0

if __name__ == '__main__':
    sys.exit( unittest( sys.argv ) )
