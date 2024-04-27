using Microsoft.AspNetCore.Mvc;
using Models;
using Services;

namespace devops_journey.Controllers;

[ApiController]
[Route("[controller]")]
public class ContactController : ControllerBase
{
    
    private readonly ILogger<ContactController> _logger;
    private readonly IContactService _contactService;

    public ContactController(ILogger<ContactController > logger, IContactService contactService)
    {
        _logger = logger;
        _contactService = contactService;
    }

    [HttpGet(Name = "v1/contacts")]
    public async Task<ActionResult<List<Contact>>> GetContacts()
    {
        // var allContacts = await _contactService.FindAllContactsAsync();
        var contacts = await _contactService.FindAllContactsAsync();
        return Ok(contacts);
        // return contacts.Any() ? Results.Ok(contacts) : Results.NotFound();
    }
}
