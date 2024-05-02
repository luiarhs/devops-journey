using Microsoft.AspNetCore.Mvc;
using Models;
using Services;

namespace devops_journey.Controllers;

[ApiController]
[Route("api/v1/[controller]")]
public class ContactsController : ControllerBase
{
    
    private readonly ILogger<ContactsController> _logger;
    private readonly IContactService _contactService;

    public ContactsController(ILogger<ContactsController > logger, IContactService contactService)
    {
        _logger = logger;
        _contactService = contactService;
    }

    [HttpGet(Name = "[controller]_[action]")]
    public async Task<ActionResult<List<Contact>>> GetContacts()
    {
        // var allContacts = await _contactService.FindAllContactsAsync();
        var contacts = await _contactService.FindAllContactsAsync();
        return Ok(contacts);
        // return contacts.Any() ? Results.Ok(contacts) : Results.NotFound();
    }
}
