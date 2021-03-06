
<property name="context">{/doc/download {Download}} {Download Package Requirements}</property>
<property name="doc(title)">Download Package Requirements</property>
<master>
<h1>Download Package Requirements</h1>

by <a href="mailto:jbank\@arsdigita.com">Joseph Bank</a>
 based
largely on the ACS Repository requirements written by <a href="mailto:tnight\@arsdigita.com">Todd Nightingale</a>
<em>This is a DRAFT</em>
<h3>I. Introduction</h3>
<p>OpenACS 4.x has a file storage module, so an obvious question
is: "Why do we need a separate download module?" The
download module is targeted at a different usage pattern and
interface. The intent of the download module is to provide an
online repository for the public (or pseudo-public) distribution of
infrequently modified files. The ACS 3.4 download module, used at
http://www.arsdigita.com/download for distribution of software
provided by ArsDigita, and the acs-repository, used at
http://www.arsdigita.com/acs-repository for distribution of ACS
packages, are the prime examples of this usage pattern. While the
file-storage module could be used for this purpose, it would be an
akward fit. Additionally, we would like to track who has downloaded
the file and have the ability to spam or charge those users as
appropriate.</p>
<h3>II. Vision Statement</h3>
<p>There are thousands of independent developers all over the world
writing their own OpenACS packages. Without a canonical
distribution point finding the packages you need becomes a
formidable task, forcing developers to duplicating each others
efforts. The download module allows us to setup a package
repository service for users to upload their own packages and
download contributed packages in order to facilitate true
development collaboration.</p>
<h3>III. System/Application Overview</h3>
<p>The OpenACS download package provides an application for
managing file distribution.</p>
<p>The package consists of the following components:</p>
<ul>
<li>A data model for storing files.</li><li>A data model for storing meta-information about files.</li><li>A data model for storing information about who has downloaded
files.</li><li>A user interface for displaying available files.</li><li>A user interface for downloading files.</li><li>A user interface for uploading files.</li><li>A user interface for administering files.</li>
</ul>
<h3>IV. Use-cases and User Scenarios</h3>

The download package is intended to support two user roles:
<ol>
<li>User (downloading and contributing)</li><li>Administrator</li>
</ol>

Joe Contributor (currently working for <em>Joe.com</em>
) writes a
piece of software used to do knowledge management (KM) for the ACS.
He packages his code using the <a href="/doc/packages">APM</a>
. Joe
feels that others could gain from using his new package so he
uploads it to the OpenACS Package Repository. Since it is in APM
format, in one step a package, version, vendor, owner and
description data are all uploaded (extracted from the .info file).
<p>Jane Admin who installed and configured the download package
chose to not allow users to download versions pending approval.
That forces her to download Joe&#39;s package from the admin pages
and install it. She notices that it isn&#39;t malicious in any way
and doesn&#39;t harm her OpenACS installation so she approves it to
go live on her package repository. Joe is informed via email that
his package was approved (because Jane set this configuration
parameter).</p>
<p>Don Downloader is scanning through the most recently uploaded
APMs on a package repository and finds Joe&#39;s KM package. He
notices that many other users have downloaded the package and have
made comments praising the package as well as <em>Joe.com</em>.
Since Ben is a follower by heart, he decides to download the
package as well and install it on his system. (Ben&#39;s crafty
friend Alyssa later informs Ben that he could have just had the APM
install directly from the repository url).</p>
<p>Benny Beancounter loves to learn about who&#39;s downloading
files from his site and what reasons they give for downloads. On a
frequent basis, Benny visits the download packages admin pages and
views a report of how many downloads occurred for each file. He then
drills down on a particular file and views a list of the users who
downloaded the file and their specified reason for downloading.</p>
<h3>V. Related Links</h3>
<ul>
<li>Design Document - <em>not present</em>.</li><li><a href="features.txt">Some Features</a></li>
</ul>
<h3>VI.A Requirements: Datamodel</h3>
<p><strong>10.0 Versioned File Storage</strong></p>
<p>OpenACS Download must provide versioned file storage.</p>
<p><strong>20.0 User Tracking</strong></p>
<p>OpenACS Download must store information about which users have
downloaded which files (including versions).</p>
<p><strong>20.0 Package Based Meta Information</strong></p>
<p>OpenACS Download must be able to store arbitrary meta
information on a per package basis. i.e. All files provided by this
instance of the package require the fields x, y and z.</p>
<h3>VI.B Requirements: Users Interface</h3>

The requirement of the user interface is to enable the user to
access package versions in the repository and upload his own
packages and versions.
<p>
<strong>100.0 Define a Package</strong> (must be logged in)</p>
<blockquote>
<strong>100.1</strong> The user must be able to create
a repository package by specifying all the necessary information:
<ul>
<li>package key (unique)</li><li>package name</li><li>package url (unique)</li><li>owner information</li><li>vendor information (optional)</li><li>Description</li><li>Description Format</li><li>package type</li><li>package category (optional)</li>
</ul><p>
<strong>100.2</strong> If the user fails to provide the required
information the package cannot be created.</p><p>
<strong>100.3</strong> If the tries to add a package with
overlapping values in any unique field the package cannot be
created.</p><p>
<strong>100.4</strong> All the package information should be
edit-able after package creation.</p>
</blockquote>
<p>
<strong>110.0 Manage Package Permissions</strong> (must be
logged in)</p>
<blockquote>
<strong>110.1</strong> The user may grant or revoke
write and administer privileges on any package which he/she has
administer privileges.
<p>
<strong>110.2</strong> The user who creates a package starts
with write and administer privileges.</p>
</blockquote>
<p>
<strong>120.0 Upload Versions</strong> (must be logged in)</p>
<blockquote>
<strong>120.1</strong> The user must be able to upload
versions of a package to the repository. These versions contain the
actual package content in a tarball (gzipped tar archive). Along
with these versions come their own meta-data:
<ul>
<li>version number (like 1.1 or 1.2.3d4)</li><li>version url (unique)</li><li>Description</li><li>Description Format</li>
</ul><p>
<strong>120.2</strong> If the user fails to provide the required
information the version cannot be created.</p><p>
<strong>120.3</strong> If the user tries to add a version with
overlapping values in any unique field the package cannot be
created.</p><p>
<strong>120.4</strong> If the user tries to upload a version
which already resides in the repository the version cannot be
created.</p><p>
<strong>120.5</strong> If the user will not be able to attempt
to upload versions into packages which he does not have write
permission on.</p>
</blockquote>
<p>
<strong>130.0 APM Auto-load</strong> (must be logged in)</p>
<blockquote>
<strong>130.1</strong> When a user is uploading an APM
all package and version information must be automatically entered
(without additional user prompting).
<p>
<strong>130.2</strong> If it is the first version of a package
all package information must be added to the repository as well as
version data.</p><p>
<strong>130.3</strong> If the package already exists then all
package information conflicts must be reported to the user.</p>
</blockquote>
<p>
<strong>140.0 Package Downloading</strong><br>
Users must be able to access packages once they are live on the
site.</p>
<blockquote>
<strong>140.1</strong> Users must be able to view the
package meta-data without downloading the package.
<p>
<strong>140.2</strong> Users must be able to download the actual
package data.</p>
</blockquote>
<p>
<strong>150.0 User commenting</strong><br>
</p>
<p>A logged-in user must be able to comment on vendors, packages,
and versions.</p>
<h3>VI.C Requirements: Administrator&#39;s Interface</h3>

The requirement of the administrator&#39;s interface is to enable
administrators to approve or reject package versions as they are
uploaded by users. Naturally any site administrator would have
rights on all the packages in the repository <strong>200.0 Approval
Parameters</strong>
<blockquote>
<p>
<strong>200.1</strong> Administrators must be able to set
whether or not packages pending approval are accessible to
users.</p><p>
<strong>200.2</strong> Administrators must be able to set
whether or not users are notified when their uploaded packages are
approved or rejected.</p>
</blockquote>
<p><strong>210.0 Version Approval</strong></p>
<p>The administrator should be able to approve or reject any
submitted package version, and enter a comment as to why the
version was rejected or approved.</p>
<h3>VII. Revision History</h3>
<table cellpadding="2" cellspacing="2" width="90%" bgcolor="#EFEFEF">
<tr bgcolor="#E0E0E0">
<th width="10%">Document Revision #</th><th width="50%">Action Taken, Notes</th><th>When?</th><th>By Whom?</th>
</tr><tr>
<td>0.3</td><td>Minor edits. Few typos &amp; links fixed. ACS changed to
OpenACS.</td><td>2/16/2002</td><td>Vinod Kurup</td>
</tr><tr>
<td>0.2</td><td>Edited to include original requirements from the ACS
Repository</td><td>12/10/2000</td><td>Joseph Bank</td>
</tr><tr>
<td>0.1</td><td>Creation</td><td>11/23/2000</td><td>Joseph Bank</td>
</tr>
</table>
<hr>
<address><a href="mailto:jbank\@arsdigita.com"></a></address>

Last modified: $&zwnj;Id: requirements.html,v 1.3 2002/09/13 16:46:34
jeffd Exp $
