VCL templates
=============
The actual structure of VCL templates used in the VaaS application is as follows::

    <VCL_TEMPLATE>
        <HEADERS/>
        <ACL/>
        <DIRECTORS>
            <DIRECTOR_{DIRECTOR}>
                <BACKEND_DEFINITION_LIST_{DIRECTOR}_{DC}/>
                <DIRECTOR_DEFINITION__{DIRECTOR}_{DC}>
                    <BACKEND_LIST_{DIRECTOR}_{DC}/>
                </DIRECTOR_DEFINITION__{DIRECTOR}_{DC}>
            </DIRECTOR_{DIRECTOR}_{DC}>
            …
            <DIRECTOR_{DIRECTOR}>
                <BACKEND_DEFINITION_LIST_{DIRECTOR}_{DC}/>
                <DIRECTOR_DEFINITION__{DIRECTOR}_{DC}/>
                ...
                <BACKEND_DEFINITION_LIST_{DIRECTOR}_{DC}/>
                <DIRECTOR_DEFINITION__{DIRECTOR}_{DC}/>
            </DIRECTOR_{DIRECTOR}>
            <DIRECTOR_INIT_{DIRECTOR}/>
            <USE_DIRECTOR_{DIRECTOR}/>
        </DIRECTORS>
        <RECV>
            <PROPER_PROTOCOL_REDIRECT/>
            <ROUTER>
                <SET_BACKEND_{DIRECTOR}/>
                ...
                <SET_BACKEND_{DIRECTOR}/>
            </ROUTER>
            <FLEXIBLE_ROUTER/>
            <TEST_ROUTER/>
            <TEST_RESPONSE_SYNTH/>
        </RECV>
        <OTHER_FUNCTIONS/>
        <EMPTY_DIRECTOR_SYNTH/>
    </VCL>

Placeholders {DIRECTOR}, {DC}, {PROBE} are replaced by appropriate director names, dc symbols or probe names.

VCL template blocks can be customized by overwriting the following tags:
-------------------
You can overwrite below tags in a VCL, using *Vcl template blocks*:

* VCL_TEMPLATE
* HEADERS
* ACL
* BACKENDS
* DIRECTORS
* RECV
* ROUTER
* PROPER_PROTOCOL_REDIRECT
* OTHER_FUNCTIONS
* EMPTY_DIRECTOR_SYNTH