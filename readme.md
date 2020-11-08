# Translating xLingPaper files with OmegaT (Using Okapi)

## Introduction

I have done this process several times, and have to figure out the details each time, so I decided to write up instructions.

### What is xLingPaper?

xLingPaper is a tool for creating linguistic papers in XML format that can be exported to PDF or HTML via various exports.

### What is OmegaT?

OmegaT is a powerful open-source Computer-Assisted Translation (CAT) tool. OmegaT has various filters that facilitate translation of various document formats. It uses translation memory to assist translation of similar documents, and can use various Machine Translation engines (Microsoft, Google, DeepL, etc) to offer suggestions. DeepL is best but doesn't offer API access at the free tier. Microsoft has a free-tier translation service. Google is a last resort, but the free tier is challenging to activate.

### What is Okapi

OmegaT can natively support many types of documents, but to translate XML documents, the Okapi plugin is recommended. The Okapi plugin can be configured to target (or ignore) various tags that you want to translate.

### contentTypes in xLingPaper

A basic section in xLingPaper looks like this:

```
<section1 id="monolingualGreeting">
    <secTitle>My File</secTitle>
    <p>Hello</p>
</section1>
```

Most XML formats use an attribute such as `xml:lang` or `xml-lang` to mark text in multiple languages, so that it each language can be styled and recognized separately.
https://www.w3.org/International/questions/qa-when-xmllang

```
<p xml-lang="en">Hello</p>
<p xml-lang="fr">Bonjour</p>
```

While xLingPaper supports `xml-lang`, `contentType` is more interesting, as xLing's content control feature allows various content classes to be hidden or shown on demand. This means that you can work on a multilingual source document that alternates between languages, and export one or both languages at will. Most block types (p, pc, li, section1, section2, etc.) and title types (i.e. titleContentChoices, labelContentChoices, etc.) in xLing support the `contentType` attribute.

```
<section1 id="greeting">
    <secTitle>
        <titleContentChoices>
            <titleContent contentType="en">My File</titleContent>
            <titleContent contentType="fr">Mon Fichier</titleContent>
        </titleContentChoices>
    </secTitle>

    <p contentType="en">Hello</p>
    <p ContentType="fr">Bonjour</p>
</section1>
```

The basic configuration below in xLingPaper would allow you to hide French or English in the output document. Add a contentControl section to your document and make sure to configure it for your language pairs.

```
<contentControl showOnlyChosenItemsInEditor="no">
    <contentTypes >
        <contentType id="en" >English</contentType>
        <contentType id="fr" >French</contentType>
    </contentTypes>
    <contentControlChoices>
        <contentControlChoice active="no" exclude="">Publish (All)</contentControlChoice>
        <contentControlChoice active="yes" exclude="fr">Publish (English)</contentControlChoice>
        <contentControlChoice active="no" exclude="en">Publish (French)</contentControlChoice>
    </contentControlChoices>
</contentControl>
```

## Preparing an XlingPaper Document for Translation.

### Creating a Multilingual Xling Paper Document, Overview

Of course, to create a multilingual document from scratch, you could manually create each paragraph in xLingPaper as below:

```
<p contentType="en">Hello</p>
<p ContentType="fr">Bonjour</p>
```

But, if you have an existing monolingual document in xLingPaper to translate, this guide will help.

In general, we will take every "paragraph" block (i.e. p, pc, li) and title block (i.e. secTitle), and prepare them for translation in OmegaT. By default, OmegaT reads the source document, identifying strings that need to be translated, and outputs a separate file with the same structure in the language. Unfortunately, this is not what we want, as it would output a separate French file that would then need to be merged with the original.

We have to "trick" OmegaT into creating a multilingual document, and fortunately, this is pretty easy with XSLT.

### XSLT Transform

You will need an XSLT engine and possibly an editing environment to use the following transforms. I am using oXygen (a paid tool), but you may be able to convince a free tool or `xxe` itself to do this work.

Note: To run transforms on xLingPaper documents, your editor/engine probaly needs to locate the dtd files (`C:\Users\[user]\AppData\Roaming\XMLmind\XMLEditor8\addon\XLingPap\dtds` on my machine) that describe an xLingPaper document. It is possible to "teach" the tool where to find those files, but I chose to copy XLingpap.dtd and all of the other dtds to the working directory (if oXygen cannot guess the path to these files, it will look in the current working directory). If you use a stylesheet, you will need to copy the relevant stylesheet XMLs (C:\Users\thoua\AppData\Roaming\XMLmind\XMLEditor8\addon\XLingPap\publisherstylesheets) and a second copy of the dtd files to `/publisherstylesheets/` inside your working directory.

I have provided 2 template XSLT transforms. You may want to expand the transform to handle larger objects such as tables, examples, or charts. The basic algorithm of `PrepareForTarget.xsl` in the xslt is this:

1. Determine a source and target language (i.e. Engligh -> French).
2. Find all of the paragraph types (p, pc, li, etc.) that we want to translate.
3. Output the existing paragraphs, making sure that they are tagged with the source language, i.e. `contentType="en"`.
4. Duplicate the content of that same paragraph (in the source language) after the previous one, making sure that the duplicate is tagged with the target language, i.e. `contentType="fr"`.
5. Find monolingual titles like `<secTitle/>` or `<shortTitle/>`, and create a `titleContentChoices` element. Duplicate the current title inside as `titleContent` , once with the source `contentType` and once with the target `contentType`.
6. The above process creates an odd file where the source language is duplicated with a correct and a wrong `contentType` tag. This is what we need to trick OmegaT into outputting a multilingual file. The duplicated source language text becomes the "prompt" that is used to generate the target language, and the duplication is overwritten when output.

The second XSLT transform is `CleanObjectsFromTarget.xsl`. While OmegaT will do a valiant effort of trying to maintain the location of tags inside your text, this can cause difficulty. I chose to remove the most common `<object>` tags from the Target Language before going to OmegaT. You will likely want to customize this transform for your own use.

### Configuring OmegaT and Okapi

You will want to install a recent version of OmegaT and create a project with the language pair you wish to translate. You also will probably want a subscription to a Machine Translation tool such as DeepL or Microsoft Cognitive Services. (This configuration is beyond the scope of this guide.)
If you were to import your xLingPaper file now, it would offer to translate ALL paragraph text, which we don't want to do. We only want to translate the text marked for the target language.

OmegaT doesn't natively understand xLingPaper XML properly, so we need to install Okapi. Grab the latest copy from here: https://bintray.com/okapi/Distribution/OmegaT_Plugin/ and copy the .jar file into `C:\Users\[user]\AppData\Roaming\OmegaT\plugins` (you may have to create the plugins folder). Restart OmegaT to enable the plugin.

Docs for the XML filter are here: https://okapiframework.org/wiki/index.php/XML_Filter .

Now we need to tell Okapi how to handle this file, and for that we will create an IST file in a working folder with this EXACT filename: `okf_xml@MyConfig.fprm`. In some older versions of Okapi, the configuration file MUST be saved as UTF-8 with no BOM (Byte Order Marker) and be saved in Unix format with LF (line feeds) instead of CRLF (Carriage Return Line Feeds), but this does not seem to be the case in current versions.

The ITS configuration below tells Okapi that we only want to translate the `text()` of tags marked with `contentType="fr"` and to ignore the whole tag if it is marked with `contentType="en"`. The second rule is intentionally different than the first, because adding `/text()` to them both confuses OmegaT, making you avoid empty source-language tags.

```
<?xml version="1.0" encoding="UTF-8"?>
<its:rules xmlns:its="http://www.w3.org/2005/11/its"
    version="1.0">
    <its:translateRule selector='//*[@contentType="fr"]/text()' translate="yes"/>
    <its:translateRule selector='//*[@contentType="en"]' translate="no"/>
</its:rules>
```

Note that this process is not limited to translating xLingPaper documents, you could target a specific language tag in generic xml (i.e. Localization files) in a similar way:

```
<?xml version="1.0" encoding="UTF-8"?>
<its:rules xmlns:its="http://www.w3.org/2005/11/its"
    version="1.0">
    <its:translateRule selector='//*[@xml-lang="fr"]/text()' translate="yes"/>
    <its:translateRule selector='//*[@xml-lang="en"]' translate="no"/>
</its:rules>
```

You could also customize the selectors to target specific elements and avoid others. The selection syntax used in the selector is XPath.

In OmegaT, go to Options>File Filters and scroll down to the newly-added `XML Files (Okapi - XML Filter)`. Select it and click `Options`. Select the `okf_xml@MyConfig.fprm` file you just created (As I have said before, the file MUST start with `okf_xml@` ). Click OK, then OK again. OmegaT will ask to reload the project, let it. If you get an error after reloading the project, something was wrong with the `fprm` file.

Note: if OmegaT chooses to use a different filter than `XML Files (Okapi - XML Filter)`, you may need to uncheck that filter while using your custom configuration.

Now, import the xLingPaper `xml` file into your Translation Project and start translating. `CTRL+M` adds the top Machine-Translation option, and you can edit the result to your liking.

After translating a few segments, you can test the output with Project>Create Translated Documents. You will find the output in the `[Project Name]/target` folder. This is the file that will become your working document. Return to OmegaT and continue to translate and refine until you are happy with the output. Creating a glossary in OmegaT will help you to maintain consistent terminology, but remember that you will have to check it yourself.

Now you can go back to work in xLingPaper.

## Later work

The above XSLT generates the needed content for translation, but as it is written, it isn't safe to run twice on the same content file (it would duplicate the duplicates). Unless you edit the code above (entirely possible), you will need to duplicate the content you want to translate "manually" and then you can run the file through OmegaT again. (You just need to identify and translate any visible content still in the source language.)

If you want to use OmegaT on other XML files, you will probably want to set the `XML Files (Okapi - XML Filter)` under `Options`>`File Filters`>`Options` back to default filter settings.
